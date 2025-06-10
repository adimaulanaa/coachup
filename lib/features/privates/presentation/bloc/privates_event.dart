
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PrivatesEvent extends Equatable {
  const PrivatesEvent();
}

class ListPrivatesEvent extends PrivatesEvent {
  final String str;
  final String fns;

  const ListPrivatesEvent(this.str, this.fns);
  
  @override
  List<Object?> get props => [str, fns];
}

class GetPrivatesEvent extends PrivatesEvent {
  final String id;

  const GetPrivatesEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}

class CreatePrivatesEvent extends PrivatesEvent {
  final PrivatesEntity data;

  const CreatePrivatesEvent(this.data);
  
  @override
  List<Object?> get props => [data];
}

class DeletePrivatesEvent extends PrivatesEvent {
  final String id;

  const DeletePrivatesEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}

class UpdatePrivatesEvent extends PrivatesEvent {
  final PrivatesEntity data;

  const UpdatePrivatesEvent(this.data);
  
  @override
  List<Object?> get props => [data];
}