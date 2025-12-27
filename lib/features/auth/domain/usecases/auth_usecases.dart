import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:injectable/injectable.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call({
    required String username,
    required String password,
  }) async {
    return await repository.login(username: username, password: password);
  }
}

@injectable
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}

@injectable
class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(String refreshToken) async {
    return await repository.refreshToken(refreshToken);
  }
}

@injectable
class IsLoggedInUseCase {
  final AuthRepository repository;

  IsLoggedInUseCase(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}

@injectable
class GetAccessTokenUseCase {
  final AuthRepository repository;

  GetAccessTokenUseCase(this.repository);

  Future<String?> call() {
    return repository.getAccessToken();
  }
}

@injectable
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}
