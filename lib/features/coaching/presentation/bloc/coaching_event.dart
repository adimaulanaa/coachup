
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

class GetCoachingEvent extends CoachingEvent {
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

class GetIdHistoryEvent extends CoachingEvent {
  final String id;

  const GetIdHistoryEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}

class GetStudentCEvent extends CoachingEvent {
  @override
  List<Object?> get props => [];
}