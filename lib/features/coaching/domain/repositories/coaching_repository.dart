import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CoachingRepository {
  Future<Either<Failure, String>> createCoaching(CoachingEntity entity);
  Future<Either<Failure, List<CoachingEntity>>> getCoachings();
  Future<Either<Failure, String>> updateCoaching(CoachingEntity entity);
  Future<Either<Failure, String>> deleteCoaching(String id);
}