part of 'orders_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent {
  final int limit;
  final int offset;
  final String? startDt;
  final String? endDt;
  final String? type;
  final bool loadMore;

  const LoadOrdersEvent({
    this.limit = 20,
    this.offset = 0,
    this.startDt,
    this.endDt,
    this.type,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [limit, offset, startDt, endDt, type, loadMore];
}

class LoadOrdersHistoryEvent extends OrderEvent {
  final int limit;
  final int offset;
  final String? startDt;
  final String? endDt;
  final String? status;
  final String? type;
  final bool loadMore;

  const LoadOrdersHistoryEvent({
    this.limit = 20,
    this.offset = 0,
    this.startDt,
    this.endDt,
    this.status,
    this.type,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [limit, offset, startDt, endDt, status, loadMore];
}

class CreateOrderEvent extends OrderEvent {
  final String type;
  final int? tableNumber;
  final int? discount;
  final List<Map<String, dynamic>> orderItems;

  const CreateOrderEvent({
    required this.type,
    this.tableNumber,
    this.discount,
    required this.orderItems,
  });

  @override
  List<Object?> get props => [type, tableNumber, orderItems];
}

class UpdateOrderEvent extends OrderEvent {
  final int id;
  final String type;
  final int userId;
  final int? tableNumber;

  const UpdateOrderEvent({
    required this.id,
    required this.type,
    required this.userId,
    this.tableNumber,
  });

  @override
  List<Object?> get props => [id, type, userId, tableNumber];
}

class DeleteOrderEvent extends OrderEvent {
  final int id;

  const DeleteOrderEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CloseOrderEvent extends OrderEvent {
  final OrderEntity order;

  const CloseOrderEvent(this.order);

  @override
  List<Object> get props => [order];
}

class PrintBillEvent extends OrderEvent {
  final OrderEntity order;

  const PrintBillEvent(this.order);

  @override
  List<Object> get props => [order];
}

class AddToCartEvent extends OrderEvent {
  final int productId;
  final String productName;
  final int price;
  final String image;

  const AddToCartEvent({
    required this.productId,
    required this.productName,
    required this.price,
    required this.image,
  });

  @override
  List<Object> get props => [productId, productName, price, image];
}

class RemoveFromCartEvent extends OrderEvent {
  final int productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearCartEvent extends OrderEvent {
  const ClearCartEvent();
}

class RetryPrintEvent extends OrderEvent {
  final OrderEntity order;
  const RetryPrintEvent(this.order);
}

class AddItemsToOrderEvent extends OrderEvent {
  final int orderId;
  final String orderNumber;
  final String type;
  final int? tableId;
  final List<Map<String, dynamic>> orderItems;
  final List<Map<String, dynamic>> oldOrderItems;

  const AddItemsToOrderEvent({
    required this.orderId,
    required this.orderNumber,
    required this.orderItems,
    required this.type,
    this.tableId,
    required this.oldOrderItems,
  });

  @override
  List<Object?> get props => [
    orderId,
    orderItems,
    oldOrderItems,
    orderNumber,
    type,
    tableId,
  ];
}

class UpdateOrderItemsEvent extends OrderEvent {
  final String type;
  final int userId;
  final int? tableNumber;
  final String password;
  final int orderId;
  final List<Map<String, dynamic>> orderItems;

  const UpdateOrderItemsEvent({
    required this.type,
    required this.userId,
    this.tableNumber,
    required this.password,
    required this.orderId,
    required this.orderItems,
  });

  @override
  List<Object?> get props => [password, orderId, orderItems];
}

class SetOrderForEditing extends OrderEvent {
  final OrderEntity order;

  const SetOrderForEditing({required this.order});

  @override
  List<Object?> get props => [order];
}

class RejectOrderEvent extends OrderEvent {
  final int id;
  final RejectOrderRequest request;

  const RejectOrderEvent({required this.id, required this.request});

  @override
  List<Object?> get props => [id, request];
}

class WatchOrdersEvent extends OrderEvent {}
