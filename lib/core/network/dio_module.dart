import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:haru_pos/core/constants/api.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/routes/app_pages.dart';
import 'package:haru_pos/core/routes/app_routes.dart';
import 'package:haru_pos/core/utils/token_service.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${Api.baseUrl}/api/v1',
        headers: {'Content-Type': 'application/json'},
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Accept'] = 'application/json';
          String? token = await getIt<TokenService>().getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('➡️  ${options.method} ${options.uri}');
          print('➡️  ${options.data}');

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            getIt<TokenService>().clearTokens();
            AppRouter.router.go(AppPages.auth);
            return handler.reject(error);
          }
          return handler.next(error);
        },
        onResponse: (response, handler) {
          // print(response.statusCode);
          return handler.next(response);
        },
      ),
    );

    return dio;
  }
}
