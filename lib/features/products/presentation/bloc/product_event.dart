part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  final int? limit;
  final int? offset;
  final int? categoryId;
  final String? search;
  final bool loadMore;

  const LoadProductsEvent({
    this.limit,
    this.offset,
    this.categoryId,
    this.search,
    this.loadMore = false,
  });

  @override
  List<Object> get props => [
    limit ?? 0,
    offset ?? 0,
    categoryId ?? 0,
    search ?? '',
    loadMore,
  ];
}

class CreateProductEvent extends ProductEvent {
  final String nameRu;
  final String nameUz;
  final int price;
  final String imagePath;
  final int categoryId;
  final bool? status;
  final String? comment;

  const CreateProductEvent({
    required this.nameRu,
    required this.nameUz,
    required this.price,
    required this.imagePath,
    required this.categoryId,
    this.status,
    this.comment,
  });

  @override
  List<Object> get props => [nameRu, nameUz, price, imagePath, categoryId];
}

class UpdateProductEvent extends ProductEvent {
  final int id;
  final String nameRu;
  final String nameUz;
  final int price;
  final String imagePath;
  final int categoryId;
  final bool? status;
  final String? comment;

  const UpdateProductEvent({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.price,
    required this.imagePath,
    required this.categoryId,
    this.status,
    this.comment,
  });

  @override
  List<Object> get props => [id, nameRu, nameUz, price, imagePath, categoryId];
}

class DeleteProductEvent extends ProductEvent {
  final int id;

  const DeleteProductEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ClearProductsEvent extends ProductEvent {}
