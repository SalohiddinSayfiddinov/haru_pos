import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String message;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.message,
  });

  @override
  List<Object> get props => [accessToken, refreshToken, message];
}

class UserEntity extends Equatable {
  final int id;
  final String username;
  final String fullName;
  final String role;
  final String? image;

  const UserEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.image,
  });

  @override
  List<Object?> get props => [id, username, fullName, role, image];
}
