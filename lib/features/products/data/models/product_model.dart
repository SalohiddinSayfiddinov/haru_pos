import 'package:haru_pos/core/constants/api.dart';

import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.nameRu,
    required super.nameUz,
    required super.price,
    required super.categoryId,
    super.status,
    super.comment,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      nameRu: json['name_ru'] ?? '',
      nameUz: json['name_uz'] ?? '',
      price: json['price'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      status: json['status'],
      comment: json['comment'],
      image: json['image'] != null ? "${Api.baseUrl}${json['image']}" : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ru': nameRu,
      'name_uz': nameUz,
      'price': price,
      'category_id': categoryId,
      'status': status,
      'comment': comment,
      'image': image,
    };
  }

  Map<String, dynamic> toCreateRequest() {
    return {
      'name_ru': nameRu,
      'name_uz': nameUz,
      'price': price,
      'category_id': categoryId,
      if (status != null) 'status': status,
      if (comment != null) 'comment': comment,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      nameRu: nameRu,
      nameUz: nameUz,
      price: price,
      categoryId: categoryId,
      status: status,
      comment: comment,
      image: image,
    );
  }
}
