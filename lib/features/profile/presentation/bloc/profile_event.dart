
import 'package:coachup/features/profile/domain/entities/profile_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final ProfileEntity update;

  const UpdateProfileEvent(this.update);
  
  @override
  List<Object?> get props => [update];
}