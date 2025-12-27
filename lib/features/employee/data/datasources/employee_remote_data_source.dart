import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '../models/employee_model.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getEmployees();
  Future<EmployeeModel> createEmployee({
    required String fullName,
    required String username,
    required String password,
    required String role,
    required XFile image,
  });
  Future<EmployeeModel> updateEmployee({
    required int id,
    required String fullName,
    required String username,
    required String password,
    required String role,
    XFile? image,
  });
  Future<void> deleteEmployee(int id);
}

@LazySingleton(as: EmployeeRemoteDataSource)
class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final Dio dio;

  EmployeeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    final response = await dio.get('/staff');

    if (response.data is List) {
      return (response.data as List)
          .map((json) => EmployeeModel.fromJson(json))
          .toList();
    }

    throw Exception('Invalid response format');
  }

  @override
  Future<EmployeeModel> createEmployee({
    required String fullName,
    required String username,
    required String password,
    required String role,
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();
    final formData = FormData.fromMap({
      'full_name': fullName,
      'username': username,
      'password': password,
      'role': role,
      'image': MultipartFile.fromBytes(bytes, filename: image.name),
    });

    final response = await dio.post('/staff/create', data: formData);

    return EmployeeModel.fromJson(response.data);
  }

  @override
  Future<EmployeeModel> updateEmployee({
    required int id,
    required String fullName,
    required String username,
    required String password,
    required String role,
    XFile? image,
  }) async {
    Uint8List? bytes;
    if (image != null) {
      bytes = await image.readAsBytes();
    }
    final formData = FormData.fromMap({
      'full_name': fullName,
      'username': username,
      if (password.isNotEmpty) 'password': password,
      'role': role,
      if (bytes != null)
        'image': MultipartFile.fromBytes(bytes, filename: image!.name),
    });

    final response = await dio.put('/staff/$id', data: formData);

    return EmployeeModel.fromJson(response.data);
  }

  @override
  Future<void> deleteEmployee(int id) async {
    await dio.delete('/staff/$id');
  }
}
