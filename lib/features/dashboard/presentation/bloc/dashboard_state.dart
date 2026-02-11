import 'package:equatable/equatable.dart';
import 'package:haru_pos/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:haru_pos/features/employee/domain/entities/employee_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardEntity dashboardData;
  final List<EmployeeEntity> employees;

  const DashboardLoaded({required this.dashboardData, required this.employees});

  @override
  List<Object> get props => [dashboardData, employees];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
