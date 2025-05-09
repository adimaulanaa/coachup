import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/coaching/domain/repositories/coaching_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteCoachingUseCase {
  final CoachingRepository repository;

  DeleteCoachingUseCase(this.repository);

  Future<Either<Failure, String>> call(String id) async {
    return await repository.deleteCoaching(id);
  }
}