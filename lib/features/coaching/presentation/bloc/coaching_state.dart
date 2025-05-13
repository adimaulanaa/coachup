import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CoachingState extends Equatable {
  const CoachingState();

  @override
  List<Object?> get props => [];
}

class CoachingInitial extends CoachingState {}

class CreateCoachingLoading extends CoachingState {}

class GetCoachingLoading extends CoachingState {}

class UpdateCoachingLoading extends CoachingState {}

class DeleteCoachingLoading extends CoachingState {}

class GetStudentCLoading extends CoachingState {}

class CreateCoachingSuccess extends CoachingState {
  final String message;

  const CreateCoachingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateCoachingFailure extends CoachingState {
  final String message;

  const CreateCoachingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetCoachingLoaded extends CoachingState {
  final List<CoachEntity> coaching;

  const GetCoachingLoaded(this.coaching);
}

class GetCoachingFailure extends CoachingState {
  final String message;

  const GetCoachingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateCoachingSuccess extends CoachingState {
  final String message;

  const UpdateCoachingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateCoachingFailure extends CoachingState {
  final String message;

  const UpdateCoachingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteCoachingSuccess extends CoachingState {
  final String message;

  const DeleteCoachingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteCoachingFailure extends CoachingState {
  final String message;

  const DeleteCoachingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetStudentCLoaded extends CoachingState {
  final List<StudentEntity> student;

  const GetStudentCLoaded(this.student);
}

class GetStudentCFailure extends CoachingState {
  final String message;

  const GetStudentCFailure(this.message);

  @override
  List<Object?> get props => [message];
}