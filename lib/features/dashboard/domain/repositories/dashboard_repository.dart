import 'package:coachup/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {
  Future<Either<Failure, String>> getDash(String entity);
}