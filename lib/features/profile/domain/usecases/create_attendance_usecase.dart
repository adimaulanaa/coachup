import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/profile/domain/entities/profile_entity.dart';
import 'package:coachup/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call() {
    return repository.getProf();
  }
}