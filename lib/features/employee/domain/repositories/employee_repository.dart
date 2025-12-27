import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees();
  Future<Either<Failure, EmployeeEntity>> createEmployee({
    required String fullName,
    required String username,
    required String password,
    required String role,
    required String imagePath,
  });
  Future<Either<Failure, EmployeeEntity>> updateEmployee({
    required int id,
    required String fullName,
    required String username,
    required String password,
    required String role,
    required String imagePath,
  });
  Future<Either<Failure, void>> deleteEmployee(int id);
}
