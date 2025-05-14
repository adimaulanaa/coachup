
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class GetDashboardEvent extends DashboardEvent {
  final int day;

  const GetDashboardEvent(this.day);
  
  @override
  List<Object?> get props => [day];
}
