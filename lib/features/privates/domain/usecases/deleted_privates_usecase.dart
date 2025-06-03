import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/privates/domain/repositories/privates_repository.dart';
import 'package:dartz/dartz.dart';

class DeletedPrivatesUseCase {
  final PrivatesRepository repository;

  DeletedPrivatesUseCase(this.repository);

  Future<Either<Failure, String>> call(String id) {
    return repository.delete(id);
  }
}