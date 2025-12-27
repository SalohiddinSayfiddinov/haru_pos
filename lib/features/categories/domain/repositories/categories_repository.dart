import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String nameRu,
    required String nameUz,
    required String imagePath,
  });
  Future<Either<Failure, CategoryEntity>> updateCategory({
    required int id,
    required String nameRu,
    required String nameUz,
    required String imagePath,
  });
  Future<Either<Failure, void>> deleteCategory(int id);
}
