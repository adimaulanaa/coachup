import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/repositories/privates_repository.dart';
import 'package:dartz/dartz.dart';

class GetPrivatesUseCase {
  final PrivatesRepository repository;

  GetPrivatesUseCase(this.repository);

  Future<Either<Failure, List<PrivatesModel>>> call(String entity) {
    return repository.get(entity);
  }
}