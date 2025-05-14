import 'package:coachup/features/dashboard/domain/usecases/create_attendance_usecase.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDash;

  DashboardBloc(
    this.getDash,
  ) : super(DashboardInitial()) {
    on<GetDashboardEvent>((event, emit) async {
      emit(GetDashboardLoading());

      final result = await getDash(event.day);
      result.fold(
        (failure) => emit(GetDashboardFailure(failure.message)),
        (success) => emit(GetDashboardLoaded(success)),
      );
    });
  }
}
