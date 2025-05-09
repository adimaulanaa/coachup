import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:coachup/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class CreateStudentsUseCase {
  final StudentsRepository repository;

  CreateStudentsUseCase(this.repository);

  Future<Either<Failure, String>> call(StudentEntity entity) async {
    return await repository.createStudents(entity);
  }
}