import 'package:coachup/features/privates/domain/usecases/created_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/get_privates_usecase.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_event.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivatesBloc extends Bloc<PrivatesEvent, PrivatesState> {
  final GetPrivatesUseCase get;
  final CreatedPrivatesUseCase create;

  PrivatesBloc(
    this.get, this.create,
  ) : super(PrivatesInitial()) {
    on<GetPrivatesEvent>((event, emit) async {
      emit(GetPrivatesLoading());

      final result = await get(event.day);
      result.fold(
        (failure) => emit(GetPrivatesFailure(failure.message)),
        (success) => emit(GetPrivatesLoaded(success)),
      );
    });

    on<CreatePrivatesEvent>((event, emit) async {
      emit(CreatedPrivatesLoading());

      final result = await create(event.data);
      result.fold(
        (failure) => emit(CreatedPrivatesFailure(failure.message)),
        (success) => emit(CreatedPrivatesSuccess(success)),
      );
    });
  }
}
