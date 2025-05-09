import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/domain/repositories/coaching_repository.dart';
import 'package:dartz/dartz.dart';

class CreateCoachingUseCase {
  final CoachingRepository repository;

  CreateCoachingUseCase(this.repository);

  Future<Either<Failure, String>> call(CoachingEntity entity) async {
    return await repository.createCoaching(entity);
  }
}