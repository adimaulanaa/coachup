import 'package:coachup/features/profile/domain/entities/profile_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class GetProfileLoading extends ProfileState {}

class UpdateProfileLoading extends ProfileState {}

class GetProfileFailure extends ProfileState {
  final String message;

  const GetProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetProfileLoaded extends ProfileState {
  final ProfileEntity data;

  const GetProfileLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateProfileFailure extends ProfileState {
  final String message;

  const UpdateProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateProfileSuccess extends ProfileState {
  final String message;

  const UpdateProfileSuccess(this.message);

  @override
  List<Object?> get props => [message];
}