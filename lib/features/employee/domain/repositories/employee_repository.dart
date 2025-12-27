import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees();
  Future<Either<Failure, EmployeeEntity>> createEmployee({
    required String fullName,
    required String username,
    required String password,
    required String role,
    required XFile image,
  });
  Future<Either<Failure, EmployeeEntity>> updateEmployee({
    required int id,
    required String fullName,
    required String username,
    required String password,
    required String role,
    XFile? image,
  });
  Future<Either<Failure, void>> deleteEmployee(int id);
}
