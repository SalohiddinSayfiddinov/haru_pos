import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/features/products/domain/entities/product_entity.dart';
import 'package:haru_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:haru_pos/features/products/presentation/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final Function(ProductEntity) onProductTap;
  final Function(ProductEntity) onAddToCart;

  const ProductsGrid({
    super.key,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onProductTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading && state.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductError && state.products.isEmpty) {
          return Center(
            child: Column(
              children: [
                Text(
                  'Ошибка загрузки продуктов',
                  style: GoogleFonts.inter(fontSize: 16.0, color: Colors.red),
                ),
                const SizedBox(height: 10.0),
                PrimaryButton(title: 'Попробовать снова', onPressed: onRefresh),
              ],
            ),
          );
        }

        final products = state.products;
        final isLoadingMore = state is ProductLoading && state.isLoadMore;
        final hasReachedMax = state.hasReachedMax;

        if (products.isEmpty) {
          return Center(
            child: Column(
              children: [
                Text(
                  'Продукты не найдены',
                  style: GoogleFonts.inter(fontSize: 16.0),
                ),
                const SizedBox(height: 10.0),
                PrimaryButton(title: 'Обновить', onPressed: onRefresh),
              ],
            ),
          );
        }

        return Column(
          children: [
            Wrap(
              spacing: 30.0,
              runSpacing: 30.0,
              children: products.map((product) {
                return ProductCard(
                  product: product,
                  onTap: () => onProductTap(product),
                  onAddToCart: () => onAddToCart(product),
                );
              }).toList(),
            ),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            if (!hasReachedMax && !isLoadingMore)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: PrimaryButton(
                  title: 'Загрузить еще',
                  onPressed: onLoadMore,
                ),
              ),
          ],
        );
      },
    );
  }
}
