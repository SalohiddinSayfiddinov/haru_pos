import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/usecases/employee_usecases.dart';

part 'employee_event.dart';
part 'employee_state.dart';

@injectable
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployeesUseCase getEmployeesUseCase;
  final CreateEmployeeUseCase createEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;

  EmployeeBloc({
    required this.getEmployeesUseCase,
    required this.createEmployeeUseCase,
    required this.updateEmployeeUseCase,
    required this.deleteEmployeeUseCase,
  }) : super(EmployeeInitial()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<CreateEmployeeEvent>(_onCreateEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployeesEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await getEmployeesUseCase();

    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (employees) => emit(EmployeesLoaded(employees)),
    );
  }

  Future<void> _onCreateEmployee(
    CreateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await createEmployeeUseCase(
      fullName: event.fullName,
      username: event.username,
      password: event.password,
      role: event.role,
      image: event.image,
    );

    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (employee) {
        emit(EmployeeOperationSuccess('Employee created successfully'));
      },
    );
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await updateEmployeeUseCase(
      id: event.id,
      fullName: event.fullName,
      username: event.username,
      password: event.password,
      role: event.role,
      image: event.image,
    );

    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (employee) {
        emit(EmployeeOperationSuccess('Employee updated successfully'));
      },
    );
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await deleteEmployeeUseCase(event.id);

    result.fold(
      (failure) => emit(EmployeeError(_mapFailureToMessage(failure))),
      (_) {
        emit(EmployeeOperationSuccess('Employee deleted successfully'));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case ConnectionFailure:
        return failure.message;
      case DatabaseFailure:
        return failure.message;
      default:
        return 'Unexpected error';
    }
  }
}
