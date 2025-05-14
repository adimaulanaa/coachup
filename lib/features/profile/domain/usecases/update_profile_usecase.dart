import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/profile/domain/entities/profile_entity.dart';
import 'package:coachup/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, String>> call(ProfileEntity entity) async {
    return await repository.updateProfile(entity);
  }
}