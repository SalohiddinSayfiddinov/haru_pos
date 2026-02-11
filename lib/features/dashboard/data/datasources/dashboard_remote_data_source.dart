import 'package:dio/dio.dart';
import 'package:haru_pos/features/dashboard/data/models/dashboard_model.dart';
import 'package:injectable/injectable.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboardData();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<DashboardModel> getDashboardData() async {
    final response = await dio.get('/dashboard');

    return DashboardModel.fromJson(response.data);
  }
}
