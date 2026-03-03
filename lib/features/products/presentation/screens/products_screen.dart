import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/core/routes/app_pages.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:haru_pos/features/products/data/models/products_screen_extra.dart';
import 'package:haru_pos/features/products/domain/entities/product_entity.dart';
import 'package:haru_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:haru_pos/features/products/presentation/widgets/category_filter.dart';
import 'package:haru_pos/features/products/presentation/widgets/edit_order_drawer.dart';
import 'package:haru_pos/features/products/presentation/widgets/order_drawer.dart';
import 'package:haru_pos/features/products/presentation/widgets/product_card.dart';
import 'package:haru_pos/features/products/presentation/widgets/products_grid.dart';
import 'package:haru_pos/features/products/presentation/widgets/products_header.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class ProductsScreen extends StatefulWidget {
  final int? tableNumber;
  const ProductsScreen({super.key, this.tableNumber});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<CategoryEntity> _categories = [];

  int? _selectedCategoryId;
  String? _searchQuery;
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupSearchListener();
    _scrollController.addListener(() {
      final state = context.read<ProductBloc>().state;

      if (state is ProductLoading && state.isLoadMore) return;
      if (state.hasReachedMax) return;
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        _loadMoreProducts();
      }
    });
  }

  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentLocale = context.locale;

    if (_lastLocale != currentLocale) {
      _lastLocale = currentLocale;
    }
  }

  void _initializeData() {
    context.read<ProductBloc>().add(const LoadProductsEvent());
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        _searchQuery = null;
        _refreshProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _refreshProducts() {
    context.read<ProductBloc>().add(
      LoadProductsEvent(categoryId: _selectedCategoryId, search: _searchQuery),
    );
  }

  void _loadMoreProducts() {
    context.read<ProductBloc>().add(
      LoadProductsEvent(
        categoryId: _selectedCategoryId,
        search: _searchQuery,
        loadMore: true,
      ),
    );
  }

  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    _refreshProducts();
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.isNotEmpty ? query : null;
      });
      _refreshProducts();
    });
  }

  Future<void> _onAddProduct() async {
    final result = await context.push(
      AppPages.addProduct,
      extra: ProductScreenExtra(isEdit: false, categories: _categories),
    );
    if (result == true && mounted) {
      context.read<ProductBloc>().add(const LoadProductsEvent());
    }
  }

  Future<void> _onProductTap(ProductEntity product) async {
    final result = await context.push(
      AppPages.addProduct,
      extra: ProductScreenExtra(
        isEdit: true,
        categories: _categories,
        product: product,
      ),
    );
    if (result == true && mounted) {
      context.read<ProductBloc>().add(const LoadProductsEvent());
    }
  }

  void _onAddToCart(ProductEntity product) {
    context.read<OrderBloc>().add(
      AddToCartEvent(
        productId: product.id,
        productName: product.nameRu,
        price: product.price,
        image: product.image,
      ),
    );
  }

  void _updateCategories(List<CategoryEntity> categories) {
    _categories.clear();
    _categories.addAll(categories);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoriesLoaded) {
            _updateCategories(state.categories);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: ProductsHeader(
                      searchController: _searchController,
                      onSearch: _onSearch,
                      onAddProduct: _onAddProduct,
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 40.0)),
                  SliverToBoxAdapter(
                    child: CategoryFilter(
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: _onCategorySelected,
                    ),
                  ),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading && state.products.isEmpty) {
                        return SliverToBoxAdapter(
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state is ProductError && state.products.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  LocaleKeys.products_load_error.tr(),
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                PrimaryButton(
                                  title: LocaleKeys.products_retry.tr(),
                                  onPressed: _refreshProducts,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final products = state.products;

                      if (products.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  LocaleKeys.products_no_products_found.tr(),
                                  style: GoogleFonts.inter(fontSize: 16.0),
                                ),
                                const SizedBox(height: 10.0),
                                PrimaryButton(
                                  title: LocaleKeys.products_refresh.tr(),
                                  onPressed: _refreshProducts,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.all(30),
                        sliver: SliverGrid.builder(
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                crossAxisSpacing: 30,
                                mainAxisSpacing: 30,
                                maxCrossAxisExtent: 240,
                                mainAxisExtent: 317,
                              ),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              onTap: () => _onProductTap(product),
                              onAddToCart: () => _onAddToCart(product),
                            );
                          },
                        ),
                      );
                      // return SliverToBoxAdapter(
                      //   child: Column(
                      //     children: [
                      //       Wrap(
                      //         spacing: 30.0,
                      //         runSpacing: 30.0,
                      //         children: products.map((product) {
                      //           return ProductCard(
                      //             product: product,
                      //             onTap: () => _onProductTap(product),
                      //             onAddToCart: () => _onAddToCart(product),
                      //           );
                      //         }).toList(),
                      //       ),
                      //       if (isLoadingMore)
                      //         const Padding(
                      //           padding: EdgeInsets.all(20.0),
                      //           child: CircularProgressIndicator(),
                      //         ),
                      //       if (!hasReachedMax && !isLoadingMore)
                      //         Padding(
                      //           padding: const EdgeInsets.all(20.0),
                      //           child: PrimaryButton(
                      //             title: LocaleKeys.products_load_more.tr(),
                      //             onPressed: _loadMoreProducts,
                      //           ),
                      //         ),
                      //     ],
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ),
            BlocConsumer<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderError) {
                  CustomSnackBar.error(message: state.message);
                } else if (state is OrderOperationSuccess) {
                  CustomSnackBar.error(message: state.message);
                  context.go(AppPages.orders);
                } else if (state is OrderCreatedPrintFailed) {
                  _showRetryDialog(state.order, state.errorMessage);
                }
              },
              builder: (context, state) {
                if (state.updatingOrder != null) {
                  return const EditOrderDrawer();
                }
                if (state.cartItems.isNotEmpty) {
                  return OrderDrawer(tableNumber: widget.tableNumber);
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
  /*
  Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductsHeader(
                        searchController: _searchController,
                        onSearch: _onSearch,
                        onAddProduct: _onAddProduct,
                      ),
                      const SizedBox(height: 40.0),
                      CategoryFilter(
                        selectedCategoryId: _selectedCategoryId,
                        onCategorySelected: _onCategorySelected,
                      ),
                      const SizedBox(height: 30.0),
                      ProductsGrid(
                        onRefresh: _refreshProducts,
                        onLoadMore: _loadMoreProducts,
                        onProductTap: _onProductTap,
                        onAddToCart: _onAddToCart,
                      ),
                    ],
                  ),
                ),
   */

  void _showRetryDialog(OrderEntity order, String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(LocaleKeys.products_printer_error_title.tr()),
        content: Text(
          LocaleKeys.products_printer_error_message.tr(
            args: [order.id.toString(), errorMessage],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              LocaleKeys.products_cancel.tr(),
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              context.read<OrderBloc>().add(RetryPrintEvent(order));
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              LocaleKeys.products_print_receipt.tr(),
              style: GoogleFonts.inter(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
