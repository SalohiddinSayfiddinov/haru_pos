import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int? limit,
    int? offset,
    int? categoryId,
    String? search,
  });
  Future<ProductModel> createProduct({
    required String nameRu,
    required String nameUz,
    required int price,
    required XFile image,
    required int categoryId,
    required String descriptionRu,
    required String descriptionUz,
    bool? status,
    String? comment,
  });
  Future<ProductModel> updateProduct({
    required int id,
    required String nameRu,
    required String nameUz,
    required int price,
    XFile? image,
    required int categoryId,
    required String descriptionRu,
    required String descriptionUz,
    bool? status,
    String? comment,
  });
  Future<void> deleteProduct(int id);
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
    int? limit,
    int? offset,
    int? categoryId,
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await dio.get('/products', queryParameters: queryParams);

    if (response.data is List) {
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    }

    throw Exception('Invalid response format');
  }

  @override
  Future<ProductModel> createProduct({
    required String nameRu,
    required String nameUz,
    required int price,
    required XFile image,
    required int categoryId,
    required String descriptionRu,
    required String descriptionUz,
    bool? status,
    String? comment,
  }) async {
    final bytes = await image.readAsBytes();
    final formData = FormData.fromMap({
      'name_ru': nameRu,
      'name_uz': nameUz,
      'price': price,
      'category_id': categoryId,
      'description_ru': descriptionRu,
      'description_uz': descriptionUz,
      'image': MultipartFile.fromBytes(bytes, filename: image.name),

      if (status != null) 'status': status,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });

    final response = await dio.post('/products/create', data: formData);

    return ProductModel.fromJson(response.data);
  }

  @override
  Future<ProductModel> updateProduct({
    required int id,
    required String nameRu,
    required String nameUz,
    required int price,
    XFile? image,
    required int categoryId,
    required String descriptionRu,
    required String descriptionUz,
    bool? status,
    String? comment,
  }) async {
    Uint8List? bytes;
    if (image != null) {
      bytes = await image.readAsBytes();
    }
    final formData = FormData.fromMap({
      'name_ru': nameRu,
      'name_uz': nameUz,
      'price': price.toString(),
      'category_id': categoryId.toString(),
      'description_ru': descriptionRu,
      'description_uz': descriptionUz,
      if (bytes != null)
        'image': MultipartFile.fromBytes(bytes, filename: image!.name),
      if (status != null) 'status': status,
      if (comment != null) 'comment': comment,
    });

    final response = await dio.patch('/products/$id', data: formData);

    return ProductModel.fromJson(response.data);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await dio.delete('/products/$id');
  }
}
