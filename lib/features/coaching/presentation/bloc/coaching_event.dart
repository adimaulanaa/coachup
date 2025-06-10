
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CoachingEvent extends Equatable {
  const CoachingEvent();
}

class CreateCoachingEvent extends CoachingEvent {
  final CoachEntity coaching;

  const CreateCoachingEvent(this.coaching);
  
  @override
  List<Object?> get props => [coaching];
}

class ListCoachingEvent extends CoachingEvent {
  final String str;
  final String fns;

  const ListCoachingEvent(this.str, this.fns);
  
  @override
  List<Object?> get props => [str, fns];
}

class GetCoachingEvent extends CoachingEvent {
  final String id;
  const GetCoachingEvent(this.id);
  @override
  List<Object?> get props => [];
}

class UpdateCoachingEvent extends CoachingEvent {
  final CoachEntity coaching;

  const UpdateCoachingEvent(this.coaching);
  
  @override
  List<Object?> get props => [coaching];
}

class DeleteCoachingEvent extends CoachingEvent {
  final String id;

  const DeleteCoachingEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}

class DetailCoachingEvent extends CoachingEvent {
  final String id;

  const DetailCoachingEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}

class GetStudentCEvent extends CoachingEvent {
  @override
  List<Object?> get props => [];
}