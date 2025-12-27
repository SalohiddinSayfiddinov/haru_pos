import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/errors.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/categories/domain/repositories/categories_repository.dart';
import 'package:injectable/injectable.dart';
import '../datasources/category_remote_data_source.dart';
import 'package:dio/dio.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String nameRu,
    required String nameUz,
    required String imagePath,
  }) async {
    try {
      final category = await remoteDataSource.createCategory(
        nameRu: nameRu,
        nameUz: nameUz,
        imagePath: imagePath,
      );
      return Right(category.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory({
    required int id,
    required String nameRu,
    required String nameUz,
    required String imagePath,
  }) async {
    try {
      final category = await remoteDataSource.updateCategory(
        id: id,
        nameRu: nameRu,
        nameUz: nameUz,
        imagePath: imagePath,
      );
      return Right(category.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await remoteDataSource.deleteCategory(id);
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
