import 'package:haru_pos/core/constants/api.dart';
import 'package:haru_pos/features/categories/data/models/categories_model.dart';
import 'package:haru_pos/features/orders/domain/entities/order_product_entity.dart';

class OrderProductModel extends OrderProductEntity {
  const OrderProductModel({
    required super.id,
    required super.nameRu,
    required super.nameUz,
    required super.price,
    required super.category,
    super.status,
    super.comment,
    required super.image,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'] ?? 0,
      nameRu: json['name_ru'] ?? '',
      nameUz: json['name_uz'] ?? '',
      price: json['price'] ?? 0,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : CategoryModel.fromJson({}),
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
      'category': category,
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
      'category': category,
      if (status != null) 'status': status,
      if (comment != null) 'comment': comment,
    };
  }

  OrderProductEntity toEntity() {
    return OrderProductEntity(
      id: id,
      nameRu: nameRu,
      nameUz: nameUz,
      price: price,
      category: category,
      status: status,
      comment: comment,
      image: image,
    );
  }
}
