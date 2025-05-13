import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/domain/repositories/coaching_repository.dart';
import 'package:dartz/dartz.dart';

class GetCoachingUseCase {
  final CoachingRepository repository;

  GetCoachingUseCase(this.repository);

  Future<Either<Failure, List<CoachEntity>>> call() async {
    return await repository.getCoachings();
  }
}
