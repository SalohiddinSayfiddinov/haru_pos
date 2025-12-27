import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/errors.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/table_entity.dart';
import '../../domain/repositories/table_repository.dart.dart';
import '../datasources/table_remote_data_source.dart';
import 'package:dio/dio.dart';

@LazySingleton(as: TableRepository)
class TableRepositoryImpl implements TableRepository {
  final TableRemoteDataSource remoteDataSource;

  TableRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TableEntity>>> getTables() async {
    try {
      final tables = await remoteDataSource.getTables();
      return Right(tables.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, TableEntity>> createTable({
    required int tableNumber,
  }) async {
    try {
      final table = await remoteDataSource.createTable(
        tableNumber: tableNumber,
      );
      return Right(table.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, TableEntity>> updateTable({
    required int id,
    required int tableNumber,
    required bool status,
  }) async {
    try {
      final table = await remoteDataSource.updateTable(
        id: id,
        tableNumber: tableNumber,
        status: status,
      );
      return Right(table.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTable(int id) async {
    try {
      await remoteDataSource.deleteTable(id);
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, TableEntity>> getTableByNumber({
    required int tableNumber,
  }) async {
    try {
      final table = await remoteDataSource.getTableByNumber(
        tableNumber: tableNumber,
      );
      return Right(table.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> bookTable({
    required String phoneNumber,
    required String fullName,
    required int tableId,
    required String dateAndTime,
  }) async {
    try {
      await remoteDataSource.bookTable(
        dateAndTime: dateAndTime,
        phoneNumber: phoneNumber,
        fullName: fullName,
        tableId: tableId,
      );
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTableBook(int id) async {
    try {
      await remoteDataSource.deleteTableBook(id);
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
