import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:coachup/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class ListStudentsUseCase {
  final StudentsRepository repository;

  ListStudentsUseCase(this.repository);

  Future<Either<Failure, List<StudentEntity>>> call() async {
    return await repository.list();
  }
}
