import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';
import 'package:haru_pos/features/categories/domain/usecases/category_usecases.dart';
import 'package:injectable/injectable.dart';

part 'categories_event.dart';
part 'categories_state.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryBloc({
    required this.getCategoriesUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
  }) : super(CategoryInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) => emit(CategoryError(_mapFailureToMessage(failure))),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await createCategoryUseCase(
      nameRu: event.nameRu,
      nameUz: event.nameUz,
      imagePath: event.imagePath,
    );

    result.fold(
      (failure) => emit(CategoryError(_mapFailureToMessage(failure))),
      (category) =>
          emit(CategoryOperationSuccess('Category created successfully')),
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await updateCategoryUseCase(
      id: event.id,
      nameRu: event.nameRu,
      nameUz: event.nameUz,
      imagePath: event.imagePath,
    );

    result.fold(
      (failure) => emit(CategoryError(_mapFailureToMessage(failure))),
      (category) =>
          emit(CategoryOperationSuccess('Category updated successfully')),
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await deleteCategoryUseCase(event.id);

    result.fold(
      (failure) => emit(CategoryError(_mapFailureToMessage(failure))),
      (_) => emit(CategoryOperationSuccess('Category deleted successfully')),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return failure.message;
      case const (ConnectionFailure):
        return failure.message;
      case const (DatabaseFailure):
        return failure.message;
      default:
        return 'Unexpected error';
    }
  }
}
