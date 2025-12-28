import 'package:dio/dio.dart';
import 'package:haru_pos/features/orders/data/models/orders_model.dart';
import 'package:injectable/injectable.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
  });
  Future<OrderModel> createOrder({
    required String type,
    required int userId,
    int? tableId,
    required List<Map<String, dynamic>> orderItems,
  });
  Future<OrderModel> addItemsToOrder({
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  });
  Future<OrderModel> updateOrderItems({
    required String type,
    required int userId,
    int? tableId,
    required String password,
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  });

  Future<OrderModel> updateOrder({
    required int id,
    required String type,
    required int userId,
    int? tableId,
  });
  Future<void> deleteOrder(int id);
  Future<void> closeOrder(int id);
}

@LazySingleton(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<OrderModel>> getOrders({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    if (startDt != null) queryParams['start_dt'] = startDt;
    if (endDt != null) queryParams['end_dt'] = endDt;

    final response = await dio.get('/orders', queryParameters: queryParams);

    if (response.data is List) {
      return (response.data as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    }

    throw Exception('Invalid response format');
  }

  @override
  Future<OrderModel> createOrder({
    required String type,
    required int userId,
    int? tableId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    final data = {'type': type, 'user_id': userId, 'order_items': orderItems};

    if (tableId != null) {
      data['table_id'] = tableId;
    }

    final response = await dio.post('/orders', data: data);
    return OrderModel.fromJson(response.data);
  }

  @override
  Future<OrderModel> updateOrder({
    required int id,
    required String type,
    required int userId,
    int? tableId,
  }) async {
    final data = {'type': type, 'user_id': userId};

    if (tableId != null) {
      data['table_id'] = tableId;
    }

    final response = await dio.put('/orders/$id', data: data);

    return OrderModel.fromJson(response.data);
  }

  @override
  Future<void> deleteOrder(int id) async {
    await dio.delete('/orders/$id');
  }

  @override
  Future<void> closeOrder(int id) async {
    await dio.put('/orders/close/$id');
  }

  @override
  Future<OrderModel> addItemsToOrder({
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    final response = await dio.post('/orders/waiter/$orderId/items', data: orderItems);
    return OrderModel.fromJson(response.data);
  }

  @override
  Future<OrderModel> updateOrderItems({
    required String type,
    required int userId,
    int? tableId,
    required String password,
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    final data = {
      'type': type,
      'user_id': userId,
      'password': password,
      'items': orderItems,
    };

    if (tableId != null) {
      data['table_id'] = tableId;
    }
    final response = await dio.put('/orders/admin/$orderId/items', data: data);
    return OrderModel.fromJson(response.data);
  }
}
