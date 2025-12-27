import 'package:equatable/equatable.dart';
import 'package:haru_pos/features/auth/domain/entities/auth_entity.dart';
import 'package:haru_pos/features/hall/domain/entities/table_entity.dart';
import 'package:haru_pos/features/orders/domain/entities/order_product_entity.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final int amount;
  final OrderProductEntity product;

  const OrderItemEntity({
    required this.id,
    required this.amount,
    required this.product,
  });

  @override
  List<Object> get props => [id, amount, product];
}

class OrderEntity extends Equatable {
  final int id;
  final String type;
  final int fullPrice;
  final TableEntity? table;
  final UserEntity? user;
  final bool active;
  final List<OrderItemEntity> orderItems;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.type,
    required this.fullPrice,
    this.table,
    required this.user,
    required this.active,
    required this.orderItems,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    fullPrice,
    table,
    user,
    orderItems,
    createdAt,
  ];
}
