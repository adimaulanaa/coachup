import 'package:coachup/core/network/dio_client.dart';
import 'package:coachup/core/network/network_info.dart';
import 'package:coachup/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:coachup/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:coachup/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:coachup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:coachup/features/dashboard/domain/usecases/create_attendance_usecase.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:coachup/features/students/data/datasources/students_local_datasource.dart';
import 'package:coachup/features/students/data/datasources/students_remote_datasource.dart';
import 'package:coachup/features/students/data/repositories/students_repository_impl.dart';
import 'package:coachup/features/students/domain/repositories/students_repository.dart';
import 'package:coachup/features/students/domain/usecases/create_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/delete_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/get_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/update_students_usecase.dart';
import 'package:coachup/features/students/presentation/bloc/students_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Dio>(() => DioClient().dio);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! ✅ Features - Dashboard
  sl.registerFactory(() => DashboardBloc(
        sl<GetDashboardUseCase>(),
      ));
  sl.registerLazySingleton(() => GetDashboardUseCase(sl()));
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      sl<DashboardRemoteDataSource>(),
      sl<DashboardLocalDataSource>(),
      sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(),
  );

  //! ✅ Features - Students
  sl.registerFactory(() => StudentsBloc(
        sl<CreateStudentsUseCase>(),
        sl<GetStudentsUseCase>(),
        sl<UpdateStudentsUseCase>(),
        sl<DeleteStudentsUseCase>(),
      ));
  sl.registerLazySingleton(() => GetStudentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateStudentsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStudentsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteStudentsUseCase(sl()));
  sl.registerLazySingleton<StudentsRepository>(
    () => StudentsRepositoryImpl(
      sl<StudentsRemoteDataSource>(),
      sl<StudentsLocalDataSource>(),
      sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<StudentsRemoteDataSource>(
    () => StudentsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<StudentsLocalDataSource>(
    () => StudentsLocalDataSourceImpl(),
  );
}
