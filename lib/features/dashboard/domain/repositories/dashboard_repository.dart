import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardEntity>> getDashboardData();
}
