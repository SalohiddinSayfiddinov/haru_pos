import 'package:equatable/equatable.dart';
import 'package:haru_pos/features/auth/domain/entities/auth_entity.dart';
import 'package:haru_pos/features/hall/domain/entities/table_entity.dart';
import 'package:haru_pos/features/orders/data/models/order_status.dart';
import 'package:haru_pos/features/orders/domain/entities/order_product_entity.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final int amount;
  final String comment;
  final OrderProductEntity product;

  const OrderItemEntity({
    required this.id,
    required this.amount,
    required this.product,
    required this.comment,
  });

  @override
  List<Object> get props => [id, amount, product];
}

class OrderRejectedSession extends Equatable {
  final int id;
  final String voidFault;
  final String comment;
  final DateTime createdAt;
  final List<OrderItemEntity> items;

  const OrderRejectedSession({
    required this.id,
    required this.voidFault,
    required this.comment,
    required this.createdAt,
    required this.items,
  });

  @override
  List<Object> get props => [id, voidFault, comment, createdAt, items];
}

class OrderEntity extends Equatable {
  final int id;
  final String orderNumber;
  final String type;
  final int fullPrice;
  final TableEntity? table;
  final UserEntity? user;
  final bool active;
  final OrderStatus status;
  final List<OrderItemEntity> orderItems;
  final List<OrderRejectedSession> rejectedSessions;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.fullPrice,
    this.table,
    required this.user,
    required this.active,
    required this.status,
    required this.orderItems,
    required this.rejectedSessions,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    type,
    fullPrice,
    table,
    user,
    status,
    orderItems,
    rejectedSessions,
    createdAt,
  ];
}
