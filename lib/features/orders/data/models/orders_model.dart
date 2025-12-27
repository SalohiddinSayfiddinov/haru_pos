import 'package:haru_pos/features/auth/data/models/user_model.dart';
import 'package:haru_pos/features/hall/data/models/table_model.dart';
import 'package:haru_pos/features/orders/data/models/order_product_model.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.amount,
    required super.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      amount: json['amount'] ?? 1,
      product: OrderProductModel.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'product': (product as OrderProductModel).toJson(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {'product_id': product.id, 'amount': amount};
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.type,
    required super.fullPrice,
    super.table,
    required super.user,
    required super.active,
    required super.orderItems,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final orderItems =
        (json['order_items'] as List?)
            ?.map((e) => OrderItemModel.fromJson(e))
            .toList() ??
        [];
    return OrderModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'dine_in',
      fullPrice: json['full_price'] ?? 0,
      table: json['table'] != null ? TableModel.fromJson(json['table']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      active: json['active'] ?? false,
      orderItems: orderItems,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'full_price': fullPrice,
      'table': table,
      'user': user,
      'order_items': orderItems
          .map((item) => (item as OrderItemModel).toJson())
          .toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateRequest() {
    return {
      'type': type,
      'user': user,
      'table': table,
      'order_items': orderItems
          .map((item) => (item as OrderItemModel).toCreateJson())
          .toList(),
    };
  }

  Map<String, dynamic> toUpdateRequest() {
    return {'type': type, 'user': user, 'table': table};
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      type: type,
      fullPrice: fullPrice,
      table: table,
      user: user,
      orderItems: orderItems,
      createdAt: createdAt,
      active: active,
    );
  }
}
