import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String nameRu,
    required String nameUz,
    required XFile image,
  });
  Future<Either<Failure, CategoryEntity>> updateCategory({
    required int id,
    required String nameRu,
    required String nameUz,
    XFile? image,
  });
  Future<Either<Failure, void>> deleteCategory(int id);
}
