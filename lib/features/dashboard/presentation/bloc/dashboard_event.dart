
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class GetDashboardEvent extends DashboardEvent {
  final String attendance;

  const GetDashboardEvent(this.attendance);
  
  @override
  List<Object?> get props => [attendance];
}
