import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/privates/domain/repositories/privates_repository.dart';
import 'package:dartz/dartz.dart';

class ListMuridPrivatesUseCase {
  final PrivatesRepository repository;

  ListMuridPrivatesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() {
    return repository.listMurid();
  }
}