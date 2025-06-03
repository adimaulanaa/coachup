import 'package:coachup/features/privates/domain/usecases/created_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/deleted_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/get_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/list_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/update_privates_usecase.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_event.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivatesBloc extends Bloc<PrivatesEvent, PrivatesState> {
  final GetPrivatesUseCase get;
  final ListPrivatesUseCase list;
  final CreatedPrivatesUseCase create;
  final DeletedPrivatesUseCase delete;
  final UpdatedPrivatesUsecase update;

  PrivatesBloc(
    this.get, this.create, this.list, this.delete, this.update,
  ) : super(PrivatesInitial()) {
    on<GetPrivatesEvent>((event, emit) async {
      emit(GetPrivatesLoading());

      final result = await get(event.id);
      result.fold(
        (failure) => emit(GetPrivatesFailure(failure.message)),
        (success) => emit(GetPrivatesLoaded(success)),
      );
    });

    on<ListPrivatesEvent>((event, emit) async {
      emit(ListPrivatesLoading());

      final result = await list(event.day);
      result.fold(
        (failure) => emit(ListPrivatesFailure(failure.message)),
        (success) => emit(ListPrivatesLoaded(success)),
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

    on<DeletePrivatesEvent>((event, emit) async {
      emit(DeletePrivatesLoading());

      final result = await delete(event.id);
      result.fold(
        (failure) => emit(DeletePrivatesFailure(failure.message)),
        (success) => emit(DeletePrivatesSuccess(success)),
      );
    });

    on<UpdatePrivatesEvent>((event, emit) async {
      emit(UpdatePrivatesLoading());

      final result = await update(event.data);
      result.fold(
        (failure) => emit(UpdatePrivatesFailure(failure.message)),
        (success) => emit(UpdatePrivatesSuccess(success)),
      );
    });
  }
}
