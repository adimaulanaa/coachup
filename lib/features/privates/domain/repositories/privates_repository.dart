import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PrivatesRepository {
  Future<Either<Failure, List<PrivatesModel>>> get(String entity);
  Future<Either<Failure, String>> created(PrivatesEntity entity);
}