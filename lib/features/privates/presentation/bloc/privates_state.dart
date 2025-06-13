import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:equatable/equatable.dart';

abstract class PrivatesState extends Equatable {
  const PrivatesState();

  @override
  List<Object?> get props => [];
}

class PrivatesInitial extends PrivatesState {}

class GetPrivatesLoading extends PrivatesState {}

class ListPrivatesLoading extends PrivatesState {}

class CreatedPrivatesLoading extends PrivatesState {}

class DeletePrivatesLoading extends PrivatesState {}

class UpdatePrivatesLoading extends PrivatesState {}

class ListMuridPrivatesLoading extends PrivatesState {}

class GetPrivatesFailure extends PrivatesState {
  final String message;

  const GetPrivatesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetPrivatesLoaded extends PrivatesState {
  final PrivatesModel data;

  const GetPrivatesLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ListPrivatesFailure extends PrivatesState {
  final String message;

  const ListPrivatesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ListPrivatesLoaded extends PrivatesState {
  final List<PrivatesModel> data;

  const ListPrivatesLoaded(this.data);

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

class DeletePrivatesSuccess extends PrivatesState {
  final String message;

  const DeletePrivatesSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeletePrivatesFailure extends PrivatesState {
  final String message;

  const DeletePrivatesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdatePrivatesSuccess extends PrivatesState {
  final String message;

  const UpdatePrivatesSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdatePrivatesFailure extends PrivatesState {
  final String message;

  const UpdatePrivatesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ListMuridPrivatesLoaded extends PrivatesState {
  final List<String> data;

  const ListMuridPrivatesLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ListMuridPrivatesFailure extends PrivatesState {
  final String message;

  const ListMuridPrivatesFailure(this.message);

  @override
  List<Object?> get props => [message];
}