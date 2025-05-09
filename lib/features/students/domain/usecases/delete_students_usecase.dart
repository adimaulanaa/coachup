import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteStudentsUseCase {
  final StudentsRepository repository;

  DeleteStudentsUseCase(this.repository);

  Future<Either<Failure, String>> call(String id) async {
    return await repository.deleteStudents(id);
  }
}