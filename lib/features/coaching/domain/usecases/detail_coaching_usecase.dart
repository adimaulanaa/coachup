import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/coaching/domain/entities/detail_coaching_entity.dart';
import 'package:coachup/features/coaching/domain/repositories/coaching_repository.dart';
import 'package:dartz/dartz.dart';

class DetailCoachingUseCase {
  final CoachingRepository repository;

  DetailCoachingUseCase(this.repository);

  Future<Either<Failure, DetailCoachingEntity>> call(String id) async {
    return await repository.detailCoaching(id);
  }
}
