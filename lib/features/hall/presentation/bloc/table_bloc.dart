import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/table_entity.dart';
import '../../domain/usecases/table_usecases.dart';

part 'table_event.dart';
part 'table_state.dart';

@injectable
class TableBloc extends Bloc<TableEvent, TableState> {
  final GetTablesUseCase getTablesUseCase;
  final GetTableByNumberUseCase getTableByNumberUseCase;
  final CreateTableUseCase createTableUseCase;
  final UpdateTableUseCase updateTableUseCase;
  final DeleteTableUseCase deleteTableUseCase;
  final DeleteTableBookUseCase deleteTableBookUseCase;
  final BookTableUseCase bookTableUseCase;

  TableBloc({
    required this.getTablesUseCase,
    required this.getTableByNumberUseCase,
    required this.createTableUseCase,
    required this.updateTableUseCase,
    required this.deleteTableUseCase,
    required this.bookTableUseCase,
    required this.deleteTableBookUseCase,
  }) : super(TableInitial()) {
    on<LoadTablesEvent>(_onLoadTables);
    on<CreateTableEvent>(_onCreateTable);
    on<UpdateTableEvent>(_onUpdateTable);
    on<DeleteTableEvent>(_onDeleteTable);
    on<DeleteTableBookEvent>(_onDeleteTableBook);
    on<ChangeTableStatusEvent>(_onChangeTableStatus);
    on<GetTableByNumberEvent>(_onGetTableByNumber);
    on<BookTableEvent>(_onBookTable);
  }

  Future<void> _onLoadTables(
    LoadTablesEvent event,
    Emitter<TableState> emit,
  ) async {
    emit(TableLoading());

    final result = await getTablesUseCase();

    result.fold(
      (failure) => emit(TableError(_mapFailureToMessage(failure))),
      (tables) => emit(TablesLoaded(tables)),
    );
  }

  Future<void> _onGetTableByNumber(
    GetTableByNumberEvent event,
    Emitter<TableState> emit,
  ) async {
    emit(TableLoading());

    final result = await getTableByNumberUseCase(
      tableNumber: event.tableNumber,
    );

    result.fold(
      (failure) => emit(TableError(_mapFailureToMessage(failure))),
      (tables) => emit(TableGotByNumber(tables)),
    );
  }

  Future<void> _onCreateTable(
    CreateTableEvent event,
    Emitter<TableState> emit,
  ) async {
    emit(TableLoading());

    final result = await createTableUseCase(tableNumber: event.tableNumber);

    result.fold((failure) => emit(TableError(_mapFailureToMessage(failure))), (
      table,
    ) {
      emit(TableOperationSuccess('Table created successfully'));
    });
  }

  Future<void> _onUpdateTable(
    UpdateTableEvent event,
    Emitter<TableState> emit,
  ) async {
    emit(TableLoading());

    final result = await updateTableUseCase(
      id: event.id,
      tableNumber: event.tableNumber,
      status: event.status,
    );

    result.fold((failure) => emit(TableError(_mapFailureToMessage(failure))), (
      table,
    ) {
      emit(TableOperationSuccess('Table updated successfully'));
    });
  }

  Future<void> _onBookTable(
    BookTableEvent event,
    Emitter<TableState> emit,
  ) async {
    emit(TableLoading());

    final result = await bookTableUseCase(
      dateAndTime: event.dateAndTime,
      phoneNumber: event.phoneNumber,
      fullName: event.fullName,
      tableId: event.tableId,
    );

    result.fold((failure) => emit(TableError(_mapFailureToMessage(failure))), (
      table,
    ) {
      emit(TableOperationSuccess('Table booked successfully'));
    });
  }

  Future<void> _onDeleteTable(
    DeleteTableEvent event,
    Emitter<TableState> emit,
  ) async {
    emit(TableLoading());

    final result = await deleteTableUseCase(event.id);

    result.fold(
      (failure) => emit(TableError(_mapFailureToMessage(failure))),
      (_) => emit(TableOperationSuccess('Table deleted successfully')),
    );
  }

  Future<void> _onDeleteTableBook(
    DeleteTableBookEvent event,
    Emitter<TableState> emit,
  ) async {
    emit(TableLoading());

    final result = await deleteTableBookUseCase(event.id);

    result.fold(
      (failure) => emit(TableError(_mapFailureToMessage(failure))),
      (_) => emit(TableOperationSuccess('Book deleted successfully')),
    );
  }

  Future<void> _onChangeTableStatus(
    ChangeTableStatusEvent event,
    Emitter<TableState> emit,
  ) async {
    final currentState = state;
    if (currentState is TablesLoaded) {
      final table = currentState.tables.firstWhere(
        (table) => table.id == event.id,
      );

      add(
        UpdateTableEvent(
          id: event.id,
          tableNumber: table.tableNumber,
          status: event.status,
        ),
      );
    }
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
