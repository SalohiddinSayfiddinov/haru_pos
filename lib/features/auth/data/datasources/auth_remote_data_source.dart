import 'package:dio/dio.dart';
import 'package:haru_pos/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String username, required String password});

  Future<void> logout();
  Future<AuthModel> refreshToken(String refreshToken);
  Future<UserModel> getCurrentUser();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    final response = await dio.post(
      '/admin/auth/login',
      data: {'username': username, 'password': password},
    );

    return AuthModel.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await dio.post('/auth/logout/');
  }

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    final response = await dio.post(
      '/auth/refresh/',
      data: {'refresh_token': refreshToken},
    );

    return AuthModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await dio.get('/admin/auth/me');
    return UserModel.fromJson(response.data);
  }
}
