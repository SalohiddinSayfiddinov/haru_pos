import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/categories/domain/repositories/categories_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await repository.getCategories();
  }
}

@injectable
class CreateCategoryUseCase {
  final CategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  Future<Either<Failure, CategoryEntity>> call({
    required String nameRu,
    required String nameUz,
    required String imagePath,
  }) async {
    return await repository.createCategory(
      nameRu: nameRu,
      nameUz: nameUz,
      imagePath: imagePath,
    );
  }
}

@injectable
class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Either<Failure, CategoryEntity>> call({
    required int id,
    required String nameRu,
    required String nameUz,
    required String imagePath,
  }) async {
    return await repository.updateCategory(
      id: id,
      nameRu: nameRu,
      nameUz: nameUz,
      imagePath: imagePath,
    );
  }
}

@injectable
class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteCategory(id);
  }
}
