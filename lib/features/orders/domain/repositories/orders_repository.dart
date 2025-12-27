import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
  });
  Future<Either<Failure, OrderEntity>> createOrder({
    required String type,
    required int userId,
    int? tableId,
    required List<Map<String, dynamic>> orderItems,
  });
  Future<Either<Failure, OrderEntity>> updateOrder({
    required int id,
    required String type,
    required int userId,
    int? tableId,
  });

  Future<Either<Failure, OrderEntity>> addItemsToOrder({
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  });
  Future<Either<Failure, OrderEntity>> updateOrderItems({
    required String type,
    required int userId,
    int? tableId,
    required String password,
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  });
  Future<Either<Failure, void>> deleteOrder(int id);

  Future<Either<Failure, void>> closeOrder(int id);
}
