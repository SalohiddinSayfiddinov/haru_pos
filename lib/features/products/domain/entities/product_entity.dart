import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String nameRu;
  final String nameUz;
  final int price;
  final int categoryId;
  final bool? status;
  final String? comment;
  final String image;
  final String descriptionRu;
  final String descriptionUz;

  const ProductEntity({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.price,
    required this.categoryId,
    required this.descriptionRu,
    required this.descriptionUz,
    this.status,
    this.comment,
    required this.image,
  });

  @override
  List<Object?> get props => [
    id,
    nameRu,
    nameUz,
    price,
    categoryId,
    status,
    comment,
    image,
  ];
}
