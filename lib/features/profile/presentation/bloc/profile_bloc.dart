import 'package:coachup/features/profile/domain/usecases/create_attendance_usecase.dart';
import 'package:coachup/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:coachup/features/profile/presentation/bloc/profile_event.dart';
import 'package:coachup/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase get;
  final UpdateProfileUseCase update;

  ProfileBloc(
    this.get,
    this.update,
  ) : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(GetProfileLoading());

      final result = await get();
      result.fold(
        (failure) => emit(GetProfileFailure(failure.message)),
        (success) => emit(GetProfileLoaded(success)),
      );
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(UpdateProfileLoading());

      final result = await update(event.update);
      result.fold(
        (failure) => emit(UpdateProfileFailure(failure.message)),
        (success) => emit(UpdateProfileSuccess(success)),
      );
    });
  }
}
