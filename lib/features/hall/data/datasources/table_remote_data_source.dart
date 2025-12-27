import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/table_model.dart';

abstract class TableRemoteDataSource {
  Future<List<TableModel>> getTables();
  Future<TableModel> createTable({required int tableNumber});
  Future<TableModel> getTableByNumber({required int tableNumber});
  Future<TableModel> updateTable({
    required int id,
    required int tableNumber,
    required bool status,
  });
  Future<void> bookTable({
    required String phoneNumber,
    required String fullName,
    required int tableId,
    required String dateAndTime,
  });
  Future<void> deleteTable(int id);
  Future<void> deleteTableBook(int id);
}

@LazySingleton(as: TableRemoteDataSource)
class TableRemoteDataSourceImpl implements TableRemoteDataSource {
  final Dio dio;

  TableRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TableModel>> getTables() async {
    final response = await dio.get('/tables');

    if (response.data is List) {
      return (response.data as List)
          .map((json) => TableModel.fromJson(json))
          .toList();
    }

    throw Exception('Invalid response format');
  }

  @override
  Future<TableModel> createTable({required int tableNumber}) async {
    final response = await dio.post(
      '/tables',
      data: {'table_number': tableNumber},
    );

    return TableModel.fromJson(response.data);
  }

  @override
  Future<TableModel> updateTable({
    required int id,
    required int tableNumber,
    required bool status,
  }) async {
    final response = await dio.put(
      '/tables/$id',
      data: {'table_number': tableNumber, 'status': status},
    );

    return TableModel.fromJson(response.data);
  }

  @override
  Future<void> deleteTable(int id) async {
    await dio.delete('/tables/$id');
  }

  @override
  Future<TableModel> getTableByNumber({required int tableNumber}) async {
    final response = await dio.get('/tables/by_number/$tableNumber');
    return TableModel.fromJson(response.data);
  }

  @override
  Future<void> bookTable({
    required String phoneNumber,
    required String fullName,
    required int tableId,
    required String dateAndTime,
  }) async {
    await dio.post(
      '/tables/book/create',
      data: {
        "phone_number": phoneNumber,
        "full_name": fullName,
        "table_id": tableId,
        "date_and_time": dateAndTime,
      },
    );
  }

  @override
  Future<void> deleteTableBook(int id) async {
    await dio.delete('/tables/book/$id');
  }
}
