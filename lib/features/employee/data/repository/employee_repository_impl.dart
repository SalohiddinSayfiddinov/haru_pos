import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/errors.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_remote_data_source.dart';
import 'package:dio/dio.dart';

@LazySingleton(as: EmployeeRepository)
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees() async {
    try {
      final employees = await remoteDataSource.getEmployees();
      return Right(employees.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity>> createEmployee({
    required String fullName,
    required String username,
    required String password,
    required String role,
    required String imagePath,
  }) async {
    try {
      final employee = await remoteDataSource.createEmployee(
        fullName: fullName,
        username: username,
        password: password,
        role: role,
        imagePath: imagePath,
      );
      return Right(employee.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity>> updateEmployee({
    required int id,
    required String fullName,
    required String username,
    required String password,
    required String role,
    required String imagePath,
  }) async {
    try {
      final employee = await remoteDataSource.updateEmployee(
        id: id,
        fullName: fullName,
        username: username,
        password: password,
        role: role,
        imagePath: imagePath,
      );
      return Right(employee.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(int id) async {
    try {
      await remoteDataSource.deleteEmployee(id);
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
