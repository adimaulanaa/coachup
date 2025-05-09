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

class GetDashboardSuccess extends DashboardState {
  final String message;

  const GetDashboardSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
