import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:coachup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardUseCase {
  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  Future<Either<Failure, DashboardEntity>> call(String entity) {
    return repository.getDash(entity);
  }
}