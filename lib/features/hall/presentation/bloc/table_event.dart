part of 'table_bloc.dart';

abstract class TableEvent extends Equatable {
  const TableEvent();

  @override
  List<Object> get props => [];
}

class LoadTablesEvent extends TableEvent {}

class GetTableByNumberEvent extends TableEvent {
  final int tableNumber;

  const GetTableByNumberEvent({required this.tableNumber});

  @override
  List<Object> get props => [tableNumber];
}

class CreateTableEvent extends TableEvent {
  final int tableNumber;

  const CreateTableEvent({required this.tableNumber});

  @override
  List<Object> get props => [tableNumber];
}

class UpdateTableEvent extends TableEvent {
  final int id;
  final int tableNumber;
  final bool status;

  const UpdateTableEvent({
    required this.id,
    required this.tableNumber,
    required this.status,
  });

  @override
  List<Object> get props => [id, tableNumber, status];
}

class DeleteTableEvent extends TableEvent {
  final int id;

  const DeleteTableEvent(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteTableBookEvent extends TableEvent {
  final int id;

  const DeleteTableBookEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ChangeTableStatusEvent extends TableEvent {
  final int id;
  final bool status;

  const ChangeTableStatusEvent({required this.id, required this.status});

  @override
  List<Object> get props => [id, status];
}

class BookTableEvent extends TableEvent {
  final String phoneNumber;
  final String fullName;
  final int tableId;
  final String dateAndTime;

  const BookTableEvent({
    required this.phoneNumber,
    required this.fullName,
    required this.tableId,
    required this.dateAndTime,
  });

  @override
  List<Object> get props => [phoneNumber, fullName, tableId, dateAndTime];
}
