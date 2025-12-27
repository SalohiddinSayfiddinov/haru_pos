import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final int id;
  final String fullName;
  final String username;
  final String role;
  final bool isSuperuser;
  final String image;

  const EmployeeEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.role,
    required this.isSuperuser,
    required this.image,
  });

  @override
  List<Object> get props => [id, fullName, username, role, isSuperuser, image];
}
