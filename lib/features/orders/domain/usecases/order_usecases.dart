import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/orders/data/models/orders_dto.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
    String? type,
  }) async {
    return await repository.getOrders(
      limit: limit,
      offset: offset,
      startDt: startDt,
      endDt: endDt,
      type: type,
    );
  }
}

@injectable
class GetOrderHistoryUseCase {
  final OrderRepository repository;

  GetOrderHistoryUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
    String? type,
  }) async {
    return await repository.getOrderHistory(
      limit: limit,
      offset: offset,
      startDt: startDt,
      endDt: endDt,
      type: type,
    );
  }
}

@injectable
class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required String type,
    required int userId,
    int? tableId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    return await repository.createOrder(
      type: type,
      userId: userId,
      tableId: tableId,
      orderItems: orderItems,
    );
  }
}

@injectable
class UpdateOrderUseCase {
  final OrderRepository repository;

  UpdateOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required int id,
    required String type,
    required int userId,
    int? tableId,
  }) async {
    return await repository.updateOrder(
      id: id,
      type: type,
      userId: userId,
      tableId: tableId,
    );
  }
}

@injectable
class DeleteOrderUseCase {
  final OrderRepository repository;

  DeleteOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteOrder(id);
  }
}

@injectable
class CloseOrderUseCase {
  final OrderRepository repository;

  CloseOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.closeOrder(id);
  }
}

@injectable
class AddItemsToOrderUseCase {
  final OrderRepository repository;

  AddItemsToOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required int orderId,
    required String type,
    int? tableId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    return await repository.addItemsToOrder(
      orderId: orderId,
      type: type,
      tableId: tableId,
      orderItems: orderItems,
    );
  }
}

@injectable
class UpdateOrderItemsUseCase {
  final OrderRepository repository;

  UpdateOrderItemsUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required String type,
    required int userId,
    int? tableId,
    required String password,
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    return await repository.updateOrderItems(
      type: type,
      userId: userId,
      tableId: tableId,
      password: password,
      orderId: orderId,
      orderItems: orderItems,
    );
  }
}

@injectable
class RejectOrderUseCase {
  final OrderRepository repository;

  RejectOrderUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int id,
    required RejectOrderRequest request,
  }) async {
    return await repository.rejectOrder(id: id, request: request);
  }
}

@injectable
class WatchOrdersUseCase {
  final OrderRepository repository;
  WatchOrdersUseCase(this.repository);

  Stream<Either<Failure, List<OrderEntity>>> call({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
  }) {
    return repository.watchOrders(
      limit: limit,
      offset: offset,
      startDt: startDt,
      endDt: endDt,
    );
  }
}
