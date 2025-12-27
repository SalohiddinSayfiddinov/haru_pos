import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthEntity>> refreshToken(String refreshToken);
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<String?> getAccessToken();
}
