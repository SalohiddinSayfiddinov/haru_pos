import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/exception.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:haru_pos/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:haru_pos/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardEntity>> getDashboardData() async {
    try {
      final remoteData = await remoteDataSource.getDashboardData();
      return Right(remoteData);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch dashboard data'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
