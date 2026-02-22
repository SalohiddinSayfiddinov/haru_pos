import 'package:equatable/equatable.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';

class TableBookEntity extends Equatable {
  final int id;
  final String phoneNumber;
  final String fullName;
  final DateTime dateAndTime;
  final int tableId;

  const TableBookEntity({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.dateAndTime,
    required this.tableId,
  });

  @override
  List<Object> get props => [id, phoneNumber, fullName, dateAndTime, tableId];
}

class TableEntity extends Equatable {
  final int id;
  final int tableNumber;
  final bool status;
  final DateTime createdAt;
  final List<TableBookEntity> tableBooks;
  final List<OrderEntity> orders;

  const TableEntity({
    required this.id,
    required this.tableNumber,
    required this.status,
    required this.createdAt,
    this.tableBooks = const [],
    this.orders = const [],
  });

  @override
  List<Object> get props => [
    id,
    tableNumber,
    status,
    createdAt,
    tableBooks,
    orders,
  ];
}
