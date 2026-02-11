import 'package:dartz/dartz.dart';
import 'package:haru_pos/core/errors/failures.dart';
import 'package:haru_pos/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:haru_pos/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<Either<Failure, DashboardEntity>> call() async {
    return await repository.getDashboardData();
  }
}
