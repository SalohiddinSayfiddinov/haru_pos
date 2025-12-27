import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String nameRu;
  final String nameUz;
  final String image;

  const CategoryEntity({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.image,
  });

  @override
  List<Object> get props => [id, nameRu, nameUz, image];
}
