import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/coaching/domain/repositories/coaching_repository.dart';
import 'package:dartz/dartz.dart';

class ListCoachingUseCase {
  final CoachingRepository repository;

  ListCoachingUseCase(this.repository);

  Future<Either<Failure, List<CoachModel>>> call(String str, String fns) async {
    return await repository.listCoachings(str, fns);
  }
}
