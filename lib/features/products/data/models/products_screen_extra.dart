import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/products/domain/entities/product_entity.dart';

class ProductScreenExtra {
  final bool isEdit;
  final List<CategoryEntity> categories;
  final ProductEntity? product;

  const ProductScreenExtra({
    required this.isEdit,
    required this.categories,
    this.product,
  });
}