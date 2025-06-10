
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:equatable/equatable.dart';

abstract class StudentsEvent extends Equatable {
  const StudentsEvent();
}

class CreateStudentsEvent extends StudentsEvent {
  final StudentEntity students;

  const CreateStudentsEvent(this.students);
  
  @override
  List<Object?> get props => [students];
}

class ListStudentsEvent extends StudentsEvent {
  
  @override
  List<Object?> get props => [];
}

class GetStudentsEvent extends StudentsEvent {
  final String id;
  const GetStudentsEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class UpdateStudentsEvent extends StudentsEvent {
  final StudentEntity students;

  const UpdateStudentsEvent(this.students);
  
  @override
  List<Object?> get props => [students];
}

class DeleteStudentsEvent extends StudentsEvent {
  final String id;

  const DeleteStudentsEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}

class GetIdHistoryEvent extends StudentsEvent {
  final String id;

  const GetIdHistoryEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}