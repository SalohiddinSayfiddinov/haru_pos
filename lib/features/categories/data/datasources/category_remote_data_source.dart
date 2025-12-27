import 'package:dio/dio.dart';
import 'package:haru_pos/features/categories/data/models/categories_model.dart';
import 'package:injectable/injectable.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> createCategory({
    required String nameRu,
    required String nameUz,
    required String imagePath,
  });
  Future<CategoryModel> updateCategory({
    required int id,
    required String nameRu,
    required String nameUz,
    required String imagePath,
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
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'name_ru': nameRu,
      'name_uz': nameUz,
      'image': await MultipartFile.fromFile(imagePath),
    });

    final response = await dio.post('/categories/create', data: formData);

    return CategoryModel.fromJson(response.data);
  }

  @override
  Future<CategoryModel> updateCategory({
    required int id,
    required String nameRu,
    required String nameUz,
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'name_ru': nameRu,
      'name_uz': nameUz,
      if (imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(imagePath),
    });

    final response = await dio.put('/categories/$id', data: formData);

    return CategoryModel.fromJson(response.data);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await dio.delete('/categories/$id');
  }
}
