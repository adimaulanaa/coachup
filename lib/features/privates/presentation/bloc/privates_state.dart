import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:equatable/equatable.dart';

abstract class PrivatesState extends Equatable {
  const PrivatesState();

  @override
  List<Object?> get props => [];
}

class PrivatesInitial extends PrivatesState {}

class GetPrivatesLoading extends PrivatesState {}

class CreatedPrivatesLoading extends PrivatesState {}

class GetPrivatesFailure extends PrivatesState {
  final String message;

  const GetPrivatesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetPrivatesLoaded extends PrivatesState {
  final List<PrivatesModel> data;

  const GetPrivatesLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CreatedPrivatesSuccess extends PrivatesState {
  final String message;

  const CreatedPrivatesSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreatedPrivatesFailure extends PrivatesState {
  final String message;

  const CreatedPrivatesFailure(this.message);

  @override
  List<Object?> get props => [message];
}