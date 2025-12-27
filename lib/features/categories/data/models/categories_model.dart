import 'package:haru_pos/core/constants/api.dart';
import 'package:haru_pos/features/categories/domain/entities/categories_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.nameRu,
    required super.nameUz,
    required super.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      nameRu: json['name_ru'] ?? '',
      nameUz: json['name_uz'] ?? '',
      image: json['image'] != null ? "${Api.baseUrl}${json['image']}" : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name_ru': nameRu, 'name_uz': nameUz, 'image': image};
  }

  Map<String, dynamic> toCreateRequest() {
    return {'name_ru': nameRu, 'name_uz': nameUz};
  }

  Map<String, dynamic> toUpdateRequest() {
    return {'name_ru': nameRu, 'name_uz': nameUz};
  }

  CategoryEntity toEntity() {
    return CategoryEntity(id: id, nameRu: nameRu, nameUz: nameUz, image: image);
  }
}
