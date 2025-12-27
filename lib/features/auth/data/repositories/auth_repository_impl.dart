import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/errors.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/core/utils/token_service.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:dio/dio.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenService tokenService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenService,
  });

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final authModel = await remoteDataSource.login(
        username: username,
        password: password,
      );

      await tokenService.saveAccessToken(authModel.accessToken);
      await tokenService.saveRefreshToken(authModel.refreshToken);

      return Right(authModel.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await tokenService.clearTokens();
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> refreshToken(String refreshToken) async {
    try {
      final authModel = await remoteDataSource.refreshToken(refreshToken);
      await tokenService.saveAccessToken(authModel.accessToken);
      await tokenService.saveRefreshToken(authModel.refreshToken);
      return Right(authModel.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final accessToken = await tokenService.getAccessToken();
    return accessToken != null;
  }

  @override
  Future<String?> getAccessToken() async {
    return await tokenService.getAccessToken();
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      if (!await tokenService.hasTokens()) {
        return Left(ServerFailure('Not authenticated'));
      }

      final user = await remoteDataSource.getCurrentUser();
      return Right(user.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
