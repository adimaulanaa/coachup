import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardEntity>> getDash(int entity);
}