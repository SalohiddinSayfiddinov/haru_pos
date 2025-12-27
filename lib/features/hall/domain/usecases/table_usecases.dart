import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:injectable/injectable.dart';
import '../entities/table_entity.dart';
import '../repositories/table_repository.dart.dart';

@injectable
class GetTablesUseCase {
  final TableRepository repository;

  GetTablesUseCase(this.repository);

  Future<Either<Failure, List<TableEntity>>> call() async {
    return await repository.getTables();
  }
}

@injectable
class CreateTableUseCase {
  final TableRepository repository;

  CreateTableUseCase(this.repository);

  Future<Either<Failure, TableEntity>> call({required int tableNumber}) async {
    return await repository.createTable(tableNumber: tableNumber);
  }
}

@injectable
class GetTableByNumberUseCase {
  final TableRepository repository;

  GetTableByNumberUseCase(this.repository);

  Future<Either<Failure, TableEntity>> call({required int tableNumber}) async {
    return await repository.getTableByNumber(tableNumber: tableNumber);
  }
}

@injectable
class UpdateTableUseCase {
  final TableRepository repository;

  UpdateTableUseCase(this.repository);

  Future<Either<Failure, TableEntity>> call({
    required int id,
    required int tableNumber,
    required bool status,
  }) async {
    return await repository.updateTable(
      id: id,
      tableNumber: tableNumber,
      status: status,
    );
  }
}

@injectable
class DeleteTableUseCase {
  final TableRepository repository;

  DeleteTableUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteTable(id);
  }
}

@injectable
class DeleteTableBookUseCase {
  final TableRepository repository;

  DeleteTableBookUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteTableBook(id);
  }
}

@injectable
class BookTableUseCase {
  final TableRepository repository;

  BookTableUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String phoneNumber,
    required String fullName,
    required int tableId,
    required String dateAndTime,
  }) async {
    return await repository.bookTable(
      tableId: tableId,
      dateAndTime: dateAndTime,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }
}
