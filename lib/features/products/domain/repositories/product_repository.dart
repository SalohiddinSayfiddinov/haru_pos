import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int? limit,
    int? offset,
    int? categoryId,
    String? search,
  });
  Future<Either<Failure, ProductEntity>> createProduct({
    required String nameRu,
    required String nameUz,
    required int price,
    required String imagePath,
    required int categoryId,
    bool? status,
    String? comment,
  });
  Future<Either<Failure, ProductEntity>> updateProduct({
    required int id,
    required String nameRu,
    required String nameUz,
    required int price,
    required String imagePath,
    required int categoryId,
    bool? status,
    String? comment,
  });
  Future<Either<Failure, void>> deleteProduct(int id);
}
