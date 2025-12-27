import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:haru_pos/features/categories/data/models/categories_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> createCategory({
    required String nameRu,
    required String nameUz,
    required XFile image,
  });
  Future<CategoryModel> updateCategory({
    required int id,
    required String nameRu,
    required String nameUz,
    XFile? image,
  });
  Future<void> deleteCategory(int id);
}

@LazySingleton(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get('/categories');

    if (response.data is List) {
      return (response.data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    }

    throw Exception('Invalid response format');
  }

  @override
  Future<CategoryModel> createCategory({
    required String nameRu,
    required String nameUz,
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();
    final formData = FormData.fromMap({
      'name_ru': nameRu,
      'name_uz': nameUz,
      'image': MultipartFile.fromBytes(bytes, filename: image.name),
    });

    final response = await dio.post('/categories/create', data: formData);

    return CategoryModel.fromJson(response.data);
  }

  @override
  Future<CategoryModel> updateCategory({
    required int id,
    required String nameRu,
    required String nameUz,
    XFile? image,
  }) async {
    Uint8List? bytes;
    if (image != null) {
      bytes = await image.readAsBytes();
    }
    final formData = FormData.fromMap({
      'name_ru': nameRu,
      'name_uz': nameUz,
      if (bytes != null)
        'image': MultipartFile.fromBytes(bytes, filename: image!.name),
    });

    final response = await dio.put('/categories/$id', data: formData);

    return CategoryModel.fromJson(response.data);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await dio.delete('/categories/$id');
  }
}
