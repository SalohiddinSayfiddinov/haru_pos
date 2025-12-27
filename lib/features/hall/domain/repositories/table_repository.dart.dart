import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import '../entities/table_entity.dart';

abstract class TableRepository {
  Future<Either<Failure, List<TableEntity>>> getTables();
  Future<Either<Failure, TableEntity>> createTable({required int tableNumber});
  Future<Either<Failure, void>> bookTable({
    required String phoneNumber,
    required String fullName,
    required int tableId,
    required String dateAndTime,
  });
  Future<Either<Failure, TableEntity>> getTableByNumber({
    required int tableNumber,
  });
  Future<Either<Failure, TableEntity>> updateTable({
    required int id,
    required int tableNumber,
    required bool status,
  });
  
  Future<Either<Failure, void>> deleteTable(int id);

  Future<Either<Failure, void>> deleteTableBook(int id);
}
