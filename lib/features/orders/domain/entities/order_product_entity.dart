import 'package:equatable/equatable.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';

class OrderProductEntity extends Equatable {
  final int id;
  final String nameRu;
  final String nameUz;
  final int price;
  final CategoryEntity category;
  final bool? status;
  final String? comment;
  final String image;

  const OrderProductEntity({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.price,
    required this.category,
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
    category,
    status,
    comment,
    image,
  ];
}
