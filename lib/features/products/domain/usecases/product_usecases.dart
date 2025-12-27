import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:injectable/injectable.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    int? limit,
    int? offset,
    int? categoryId,
    String? search,
  }) async {
    return await repository.getProducts(
      limit: limit,
      offset: offset,
      categoryId: categoryId,
      search: search,
    );
  }
}

@injectable
class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call({
    required String nameRu,
    required String nameUz,
    required int price,
    required String imagePath,
    required int categoryId,
    bool? status,
    String? comment,
  }) async {
    return await repository.createProduct(
      nameRu: nameRu,
      nameUz: nameUz,
      price: price,
      imagePath: imagePath,
      categoryId: categoryId,
      status: status,
      comment: comment,
    );
  }
}

@injectable
class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call({
    required int id,
    required String nameRu,
    required String nameUz,
    required int price,
    required String imagePath,
    required int categoryId,
    bool? status,
    String? comment,
  }) async {
    return await repository.updateProduct(
      id: id,
      nameRu: nameRu,
      nameUz: nameUz,
      price: price,
      imagePath: imagePath,
      categoryId: categoryId,
      status: status,
      comment: comment,
    );
  }
}

@injectable
class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteProduct(id);
  }
}
