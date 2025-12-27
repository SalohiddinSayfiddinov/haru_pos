part of 'categories_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoriesEvent extends CategoryEvent {}

class CreateCategoryEvent extends CategoryEvent {
  final String nameRu;
  final String nameUz;
  final String imagePath;

  const CreateCategoryEvent({
    required this.nameRu,
    required this.nameUz,
    required this.imagePath,
  });

  @override
  List<Object> get props => [nameRu, nameUz, imagePath];
}

class UpdateCategoryEvent extends CategoryEvent {
  final int id;
  final String nameRu;
  final String nameUz;
  final String imagePath;

  const UpdateCategoryEvent({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.imagePath,
  });

  @override
  List<Object> get props => [id, nameRu, nameUz, imagePath];
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object> get props => [id];
}
