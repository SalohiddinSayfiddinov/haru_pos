import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:haru_pos/core/models/response_model.dart';
import 'package:haru_pos/features/orders/data/models/orders_dto.dart';
import 'package:haru_pos/features/orders/data/models/orders_model.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/io.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
    String? type,
  });
  Future<ApiResponseModel<OrderModel>> getOrdersHistory({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
    String? type,
  });
  Future<OrderModel> createOrder({
    required String type,
    required int userId,
    int? tableId,
    required List<Map<String, dynamic>> orderItems,
  });
  Future<OrderModel> addItemsToOrder({
    required int orderId,
    required String type,
    int? tableId,
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
  Future<void> rejectOrder(int id, RejectOrderRequest request);
  Stream<List<OrderModel>> watchOrders({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
    List<String>? orderTypes,
  });
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
    String? type,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    if (startDt != null) queryParams['start_dt'] = startDt;
    if (endDt != null) queryParams['end_dt'] = endDt;
    if (type != null) queryParams['order_types'] = [type];

    final response = await dio.get('/orders', queryParameters: queryParams);

    if (response.data['orders'] is List) {
      return (response.data['orders'] as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<ApiResponseModel<OrderModel>> getOrdersHistory({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
    String? type,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    if (startDt != null) queryParams['start_dt'] = startDt;
    if (endDt != null) queryParams['end_dt'] = endDt;
    if (type != null) queryParams['order_types'] = [type];

    final response = await dio.get(
      '/orders/history',
      queryParameters: queryParams,
    );
    return ApiResponseModel<OrderModel>.fromJson(
      response.data,
      (json) => OrderModel.fromJson(json),
    );
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
    required String type,
    int? tableId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    final data = {'type': type, 'items': orderItems};

    if (tableId != null) {
      data['table_id'] = tableId;
    }

    final response = await dio.post(
      '/orders/waiter/$orderId/items',
      data: data,
    );
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

  @override
  Future<void> rejectOrder(int id, RejectOrderRequest request) async {
    await dio.post('/orders/$id/reject', data: request.toJson());
  }

  @override
  Stream<List<OrderModel>> watchOrders({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
    List<String>? orderTypes,
  }) {
    final channel = IOWebSocketChannel.connect(
      'wss://api.haru-sushi.uz/ws/orders',
    );

    channel.sink.add(
      jsonEncode({
        "offset": offset ?? 0,
        "limit": limit ?? 100,
        "start_dt": startDt,
        "end_dt": endDt,
        "order_types": orderTypes ?? ["takeaway", "dine_in"],
        "interval_sec": 2.0,
      }),
    );

    return channel.stream.map((data) {
      final decoded = jsonDecode(data);
      if (decoded['payload']['orders'] is List) {
        return (decoded['payload']['orders'] as List)
            .map((json) => OrderModel.fromJson(json))
            .toList();
      }
      return [];
    });
  }
}
