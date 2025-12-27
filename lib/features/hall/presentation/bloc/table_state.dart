part of 'table_bloc.dart';

abstract class TableState extends Equatable {
  const TableState();

  @override
  List<Object> get props => [];
}

class TableInitial extends TableState {}

class TableLoading extends TableState {}

class TablesLoaded extends TableState {
  final List<TableEntity> tables;

  const TablesLoaded(this.tables);

  @override
  List<Object> get props => [tables];
}

class TableGotByNumber extends TableState {
  final TableEntity table;

  const TableGotByNumber(this.table);

  @override
  List<Object> get props => [table];
}

class TableOperationSuccess extends TableState {
  final String message;

  const TableOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TableError extends TableState {
  final String message;

  const TableError(this.message);

  @override
  List<Object> get props => [message];
}
