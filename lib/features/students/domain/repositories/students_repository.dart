import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:dartz/dartz.dart';

abstract class StudentsRepository {
  Future<Either<Failure, String>> createStudents(StudentEntity entity);
  Future<Either<Failure, List<StudentEntity>>> getStudentss();
  Future<Either<Failure, String>> updateStudents(StudentEntity entity);
  Future<Either<Failure, String>> deleteStudents(String id);
}