import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/privates/domain/repositories/privates_repository.dart';
import 'package:dartz/dartz.dart';

class UpdatedPrivatesUsecase {
  final PrivatesRepository repository;

  UpdatedPrivatesUsecase(this.repository);

  Future<Either<Failure, String>> call(PrivatesEntity entity) {
    return repository.updated(entity);
  }
}