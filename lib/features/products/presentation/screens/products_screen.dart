import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/routes/app_pages.dart';
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
import 'package:haru_pos/features/products/presentation/widgets/products_grid.dart';
import 'package:haru_pos/features/products/presentation/widgets/products_header.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<CategoryEntity> _categories = [];

  int? _selectedCategoryId;
  String? _searchQuery;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupSearchListener();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<ProductBloc>()),
        BlocProvider.value(value: context.read<CategoryBloc>()),
      ],
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoriesLoaded) {
              _updateCategories(state.categories);
            }
          },
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
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
                ),
                BlocConsumer<OrderBloc, OrderState>(
                  listener: (context, state) {
                    if (state is OrderError) {
                      CustomSnackBar.error(message: state.message);
                    } else if (state is OrderOperationSuccess) {
                      CustomSnackBar.error(message: state.message);
                    } else if (state is OrderCreatedPrintFailed) {
                      _showRetryDialog(state.order, state.errorMessage);
                    }
                  },
                  builder: (context, state) {
                    if (state.updatingOrder != null) {
                      return const EditOrderDrawer();
                    }
                    if (state.cartItems.isNotEmpty) {
                      return const OrderDrawer();
                    }
                    return SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRetryDialog(OrderEntity order, String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Printerda xatolik"),
        content: Text(
          "Buyurtma #${order.id} yaratildi, lekin oshxonaga bormadi.\n\n$errorMessage",
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Отмена',
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
              'Chek chiqarish',
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
