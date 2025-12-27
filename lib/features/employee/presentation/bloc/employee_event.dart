part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployeesEvent extends EmployeeEvent {}

class CreateEmployeeEvent extends EmployeeEvent {
  final String fullName;
  final String username;
  final String password;
  final String role;
  final String imagePath;

  const CreateEmployeeEvent({
    required this.fullName,
    required this.username,
    required this.password,
    required this.role,
    required this.imagePath,
  });

  @override
  List<Object> get props => [fullName, username, password, role, imagePath];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final int id;
  final String fullName;
  final String username;
  final String password;
  final String role;
  final String imagePath;

  const UpdateEmployeeEvent({
    required this.id,
    required this.fullName,
    required this.username,
    required this.password,
    required this.role,
    required this.imagePath,
  });

  @override
  List<Object> get props => [id, fullName, username, password, role, imagePath];
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final int id;

  const DeleteEmployeeEvent(this.id);

  @override
  List<Object> get props => [id];
}
