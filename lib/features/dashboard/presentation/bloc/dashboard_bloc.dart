import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:haru_pos/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:haru_pos/features/employee/domain/entities/employee_entity.dart';
import 'package:haru_pos/features/employee/domain/repositories/employee_repository.dart';
import 'package:injectable/injectable.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;
  final EmployeeRepository employeeRepository;

  DashboardBloc({
    required this.dashboardRepository,
    required this.employeeRepository,
  }) : super(DashboardInitial()) {
    on<GetDashboardData>(_onGetDashboardData);
  }

  Future<void> _onGetDashboardData(
    GetDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final results = await Future.wait([
      dashboardRepository.getDashboardData(),
      employeeRepository.getEmployees(),
    ]);

    final dashboardResult = results[0] as Either<Failure, DashboardEntity>;
    final employeesResult = results[1] as Either<Failure, List<EmployeeEntity>>;

    if (dashboardResult.isLeft()) {
      return emit(
        DashboardError(
          dashboardResult.swap().getOrElse(() => throw Exception()).message,
        ),
      );
    }

    if (employeesResult.isLeft()) {
      return emit(
        DashboardError(
          employeesResult.swap().getOrElse(() => throw Exception()).message,
        ),
      );
    }

    emit(
      DashboardLoaded(
        dashboardData: dashboardResult.getOrElse(() => throw Exception()),
        employees: employeesResult.getOrElse(() => throw Exception()),
      ),
    );
  }
}
