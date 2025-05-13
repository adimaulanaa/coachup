import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/coaching/domain/repositories/coaching_repository.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:dartz/dartz.dart';

class GetStudentCUseCase {
  final CoachingRepository repository;

  GetStudentCUseCase(this.repository);

  Future<Either<Failure, List<StudentEntity>>> call() async {
    return await repository.getStudentc();
  }
}
