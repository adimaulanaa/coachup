
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PrivatesEvent extends Equatable {
  const PrivatesEvent();
}

class GetPrivatesEvent extends PrivatesEvent {
  final String day;

  const GetPrivatesEvent(this.day);
  
  @override
  List<Object?> get props => [day];
}

class CreatePrivatesEvent extends PrivatesEvent {
  final PrivatesEntity data;

  const CreatePrivatesEvent(this.data);
  
  @override
  List<Object?> get props => [data];
}
