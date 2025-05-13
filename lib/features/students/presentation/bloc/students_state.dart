import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:equatable/equatable.dart';

abstract class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object?> get props => [];
}

class StudentsInitial extends StudentsState {}

class CreateStudentsLoading extends StudentsState {}

class GetStudentsLoading extends StudentsState {}

class UpdateStudentsLoading extends StudentsState {}

class DeleteStudentsLoading extends StudentsState {}

class CreateStudentsSuccess extends StudentsState {
  final String message;

  const CreateStudentsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateStudentsFailure extends StudentsState {
  final String message;

  const CreateStudentsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetStudentsLoaded extends StudentsState {
  final List<StudentEntity> students;

  const GetStudentsLoaded(this.students);
}

class GetStudentsFailure extends StudentsState {
  final String message;

  const GetStudentsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateStudentsSuccess extends StudentsState {
  final String message;

  const UpdateStudentsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateStudentsFailure extends StudentsState {
  final String message;

  const UpdateStudentsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteStudentsSuccess extends StudentsState {
  final String message;

  const DeleteStudentsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteStudentsFailure extends StudentsState {
  final String message;

  const DeleteStudentsFailure(this.message);

  @override
  List<Object?> get props => [message];
}