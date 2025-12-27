import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/errors.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:haru_pos/features/orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    int? limit,
    int? offset,
    String? startDt,
    String? endDt,
  }) async {
    try {
      final orders = await remoteDataSource.getOrders(
        limit: limit,
        offset: offset,
        startDt: startDt,
        endDt: endDt,
      );
      return Right(orders.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required String type,
    required int userId,
    int? tableId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      final order = await remoteDataSource.createOrder(
        type: type,
        userId: userId,
        tableId: tableId,
        orderItems: orderItems,
      );
      return Right(order.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrder({
    required int id,
    required String type,
    required int userId,
    int? tableId,
  }) async {
    try {
      final order = await remoteDataSource.updateOrder(
        id: id,
        type: type,
        userId: userId,
        tableId: tableId,
      );
      return Right(order.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(int id) async {
    try {
      await remoteDataSource.deleteOrder(id);
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> closeOrder(int id) async {
    try {
      await remoteDataSource.closeOrder(id);
      return const Right(null);
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> addItemsToOrder({
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      final order = await remoteDataSource.addItemsToOrder(
        orderId: orderId,
        orderItems: orderItems,
      );
      return Right(order.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderItems({
    required String password,
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      final order = await remoteDataSource.updateOrderItems(
        password: password,
        orderId: orderId,
        orderItems: orderItems,
      );
      return Right(order.toEntity());
    } on DioException catch (e) {
      final errorMessage = handleDioError(e);
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
