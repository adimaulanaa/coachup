import 'package:coachup/features/coaching/domain/usecases/create_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/delete_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/detail_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/get_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/get_studentc_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/update_coaching_usecase.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_event.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachingBloc extends Bloc<CoachingEvent, CoachingState> {
  final CreateCoachingUseCase create;
  final GetCoachingUseCase get;
  final DetailCoachingUseCase detail;
  final UpdateCoachingUseCase update;
  final DeleteCoachingUseCase delete;
  final GetStudentCUseCase student;

  CoachingBloc(
    this.create,
    this.get,
    this.update,
    this.delete,
    this.student, this.detail,
  ) : super(CoachingInitial()) {
    on<CreateCoachingEvent>((event, emit) async {
      emit(CreateCoachingLoading());

      final result = await create(event.coaching);
      result.fold(
        (failure) => emit(CreateCoachingFailure(failure.message)),
        (success) => emit(CreateCoachingSuccess(success)),
      );
    });

    on<GetCoachingEvent>((event, emit) async {
      emit(GetCoachingLoading());

      final result = await get();
      result.fold(
        (failure) => emit(GetCoachingFailure(failure.message)),
        (success) => emit(GetCoachingLoaded(success)),
      );
    });

    on<UpdateCoachingEvent>((event, emit) async {
      emit(UpdateCoachingLoading());

      final result = await update(event.coaching);
      result.fold(
        (failure) => emit(UpdateCoachingFailure(failure.message)),
        (success) => emit(UpdateCoachingSuccess(success)),
      );
    });

    on<DeleteCoachingEvent>((event, emit) async {
      emit(DeleteCoachingLoading());

      final result = await delete(event.id);
      result.fold(
        (failure) => emit(DeleteCoachingFailure(failure.message)),
        (success) => emit(DeleteCoachingSuccess(success)),
      );
    });

    on<GetStudentCEvent>((event, emit) async {
      emit(GetStudentCLoading());

      final result = await student();
      result.fold(
        (failure) => emit(GetStudentCFailure(failure.message)),
        (success) => emit(GetStudentCLoaded(success)),
      );
    });

    on<DetailCoachingEvent>((event, emit) async {
      emit(DetailCoachingLoading());

      final result = await detail(event.id);
      result.fold(
        (failure) => emit(DetailCoachingFailure(failure.message)),
        (success) => emit(DetailCoachingLoaded(success)),
      );
    });
  }
}
