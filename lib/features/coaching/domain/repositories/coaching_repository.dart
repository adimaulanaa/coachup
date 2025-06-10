import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/domain/entities/detail_coaching_entity.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CoachingRepository {
  Future<Either<Failure, String>> createCoaching(CoachEntity entity);
  Future<Either<Failure, List<CoachModel>>> listCoachings(String str, String fns);
  Future<Either<Failure, CoachEntity>> getCoachings(String id);
  Future<Either<Failure, String>> updateCoaching(CoachEntity entity);
  Future<Either<Failure, String>> deleteCoaching(String id);
  Future<Either<Failure, DetailCoachingEntity>> detailCoaching(String id);
  Future<Either<Failure, List<StudentEntity>>> getStudentc();
}