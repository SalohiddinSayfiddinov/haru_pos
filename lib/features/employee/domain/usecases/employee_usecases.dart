import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

@injectable
class GetEmployeesUseCase {
  final EmployeeRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<Either<Failure, List<EmployeeEntity>>> call() async {
    return await repository.getEmployees();
  }
}

@injectable
class CreateEmployeeUseCase {
  final EmployeeRepository repository;

  CreateEmployeeUseCase(this.repository);

  Future<Either<Failure, EmployeeEntity>> call({
    required String fullName,
    required String username,
    required String password,
    required String role,
    required XFile image,
  }) async {
    return await repository.createEmployee(
      fullName: fullName,
      username: username,
      password: password,
      role: role,
      image: image,
    );
  }
}

@injectable
class UpdateEmployeeUseCase {
  final EmployeeRepository repository;

  UpdateEmployeeUseCase(this.repository);

  Future<Either<Failure, EmployeeEntity>> call({
    required int id,
    required String fullName,
    required String username,
    required String password,
    required String role,
    XFile? image,
  }) async {
    return await repository.updateEmployee(
      id: id,
      fullName: fullName,
      username: username,
      password: password,
      role: role,
      image: image,
    );
  }
}

@injectable
class DeleteEmployeeUseCase {
  final EmployeeRepository repository;

  DeleteEmployeeUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteEmployee(id);
  }
}
