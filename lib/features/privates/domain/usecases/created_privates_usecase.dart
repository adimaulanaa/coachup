import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/privates/domain/repositories/privates_repository.dart';
import 'package:dartz/dartz.dart';

class CreatedPrivatesUseCase {
  final PrivatesRepository repository;

  CreatedPrivatesUseCase(this.repository);

  Future<Either<Failure, String>> call(PrivatesEntity entity) {
    return repository.created(entity);
  }
}