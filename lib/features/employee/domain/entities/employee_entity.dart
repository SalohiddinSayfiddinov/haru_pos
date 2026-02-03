import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final int id;
  final String fullName;
  final String username;
  final String role;
  final bool isSuperuser;
  final String image;
  final int limit;
  final List<LimitEntity> limits;

  const EmployeeEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.role,
    required this.isSuperuser,
    required this.image,
    required this.limit,
    required this.limits,
  });

  @override
  List<Object> get props => [id, fullName, username, role, isSuperuser, image];
}

class LimitEntity extends Equatable {
  final int id;
  final int money;
  final String createdAt;
  final String updatedAt;

  const LimitEntity({
    required this.id,
    required this.money,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, money, createdAt, updatedAt];
}
