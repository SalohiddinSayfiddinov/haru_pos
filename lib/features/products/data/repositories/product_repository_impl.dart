import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/errors.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import 'package:dio/dio.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int? limit,
    int? offset,
    int? categoryId,
    String? search,
  }) async {
    try {
      final products = await remoteDataSource.getProducts(
        limit: limit,
        offset: offset,
        categoryId: categoryId,
        search: search,
      );
      return Right(products.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct({
    required String nameRu,
    required String nameUz,
    required int price,
    required XFile image,
    required int categoryId,
    required String descriptionRu,
    required String descriptionUz,
    bool? status,
    String? comment,
  }) async {
    try {
      final product = await remoteDataSource.createProduct(
        nameRu: nameRu,
        nameUz: nameUz,
        price: price,
        image: image,
        categoryId: categoryId,
        status: status,
        comment: comment,
        descriptionRu: descriptionRu,
        descriptionUz: descriptionUz,
      );
      return Right(product.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct({
    required int id,
    required String nameRu,
    required String nameUz,
    required int price,
    XFile? image,
    required int categoryId,
    required String descriptionRu,
    required String descriptionUz,
    bool? status,
    String? comment,
  }) async {
    try {
      final product = await remoteDataSource.updateProduct(
        id: id,
        nameRu: nameRu,
        nameUz: nameUz,
        price: price,
        image: image,
        categoryId: categoryId,
        descriptionRu: descriptionRu,
        descriptionUz: descriptionUz,
        status: status,
        comment: comment,
      );
      return Right(product.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
