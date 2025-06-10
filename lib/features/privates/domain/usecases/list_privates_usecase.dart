import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/repositories/privates_repository.dart';
import 'package:dartz/dartz.dart';

class ListPrivatesUseCase {
  final PrivatesRepository repository;

  ListPrivatesUseCase(this.repository);

  Future<Either<Failure, List<PrivatesModel>>> call(String str, String fns) {
    return repository.list(str, fns);
  }
}