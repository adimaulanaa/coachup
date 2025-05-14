import 'package:coachup/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class GetDashboardLoading extends DashboardState {}

class GetDashboardFailure extends DashboardState {
  final String message;

  const GetDashboardFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GetDashboardLoaded extends DashboardState {
  final DashboardEntity data;

  const GetDashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
