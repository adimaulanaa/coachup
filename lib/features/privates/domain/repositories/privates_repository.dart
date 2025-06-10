import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PrivatesRepository {
  Future<Either<Failure, PrivatesModel>> get(String id);
  Future<Either<Failure, String>> delete(String id);
  Future<Either<Failure, List<PrivatesModel>>> list(String str, String fns);
  Future<Either<Failure, String>> created(PrivatesEntity entity);
  Future<Either<Failure, String>> updated(PrivatesEntity entity);
}