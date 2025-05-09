import 'package:coachup/features/students/domain/usecases/create_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/delete_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/get_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/update_students_usecase.dart';
import 'package:coachup/features/students/presentation/bloc/students_event.dart';
import 'package:coachup/features/students/presentation/bloc/students_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final CreateStudentsUseCase create;
  final GetStudentsUseCase get;
  final UpdateStudentsUseCase update;
  final DeleteStudentsUseCase delete;

  StudentsBloc(
    this.create,
    this.get,
    this.update,
    this.delete,
  ) : super(StudentsInitial()) {
    on<CreateStudentsEvent>((event, emit) async {
      emit(CreateStudentsLoading());

      final result = await create(event.students);
      result.fold(
        (failure) => emit(CreateStudentsFailure(failure.message)),
        (success) => emit(CreateStudentsSuccess(success)),
      );
    });

    on<GetStudentsEvent>((event, emit) async {
      emit(GetStudentsLoading());

      final result = await get();
      result.fold(
        (failure) => emit(GetStudentsFailure(failure.message)),
        (success) => emit(GetStudentsLoaded(success)),
      );
    });

    on<UpdateStudentsEvent>((event, emit) async {
      emit(UpdateStudentsLoading());

      final result = await update(event.students);
      result.fold(
        (failure) => emit(UpdateStudentsFailure(failure.message)),
        (success) => emit(UpdateStudentsSuccess(success)),
      );
    });

    on<DeleteStudentsEvent>((event, emit) async {
      emit(DeleteStudentsLoading());

      final result = await delete(event.id);
      result.fold(
        (failure) => emit(DeleteStudentsFailure(failure.message)),
        (success) => emit(DeleteStudentsSuccess(success)),
      );
    });
  }
}
