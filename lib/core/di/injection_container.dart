import 'package:coachup/core/network/dio_client.dart';
import 'package:coachup/core/network/network_info.dart';
import 'package:coachup/features/coaching/data/datasources/coaching_local_datasource.dart';
import 'package:coachup/features/coaching/data/datasources/coaching_remote_datasource.dart';
import 'package:coachup/features/coaching/data/repositories/coaching_repository_impl.dart';
import 'package:coachup/features/coaching/domain/repositories/coaching_repository.dart';
import 'package:coachup/features/coaching/domain/usecases/create_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/delete_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/detail_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/get_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/get_studentc_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/list_coaching_usecase.dart';
import 'package:coachup/features/coaching/domain/usecases/update_coaching_usecase.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_bloc.dart';
import 'package:coachup/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:coachup/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:coachup/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:coachup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:coachup/features/dashboard/domain/usecases/create_attendance_usecase.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:coachup/features/privates/data/datasources/privates_local_datasource.dart';
import 'package:coachup/features/privates/data/datasources/privates_remote_datasource.dart';
import 'package:coachup/features/privates/data/repositories/privates_repository_impl.dart';
import 'package:coachup/features/privates/domain/repositories/privates_repository.dart';
import 'package:coachup/features/privates/domain/usecases/created_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/deleted_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/get_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/list_privates_usecase.dart';
import 'package:coachup/features/privates/domain/usecases/update_privates_usecase.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_bloc.dart';
import 'package:coachup/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:coachup/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:coachup/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:coachup/features/profile/domain/repositories/profile_repository.dart';
import 'package:coachup/features/profile/domain/usecases/create_attendance_usecase.dart';
import 'package:coachup/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:coachup/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:coachup/features/students/data/datasources/students_local_datasource.dart';
import 'package:coachup/features/students/data/datasources/students_remote_datasource.dart';
import 'package:coachup/features/students/data/repositories/students_repository_impl.dart';
import 'package:coachup/features/students/domain/repositories/students_repository.dart';
import 'package:coachup/features/students/domain/usecases/create_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/delete_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/get_students_usecase.dart';
import 'package:coachup/features/students/domain/usecases/list_students_usecase.dart';
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

  //! ✅ Features - Coaching
  sl.registerFactory(() => CoachingBloc(
        sl<CreateCoachingUseCase>(),
        sl<GetCoachingUseCase>(),
        sl<UpdateCoachingUseCase>(),
        sl<DeleteCoachingUseCase>(),
        sl<GetStudentCUseCase>(),
        sl<DetailCoachingUseCase>(),
        sl<ListCoachingUseCase>(),
      ));
  sl.registerLazySingleton(() => GetCoachingUseCase(sl()));
  sl.registerLazySingleton(() => CreateCoachingUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCoachingUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCoachingUseCase(sl()));
  sl.registerLazySingleton(() => GetStudentCUseCase(sl()));
  sl.registerLazySingleton(() => DetailCoachingUseCase(sl()));
  sl.registerLazySingleton(() => ListCoachingUseCase(sl()));
  sl.registerLazySingleton<CoachingRepository>(
    () => CoachingRepositoryImpl(
      sl<CoachingRemoteDataSource>(),
      sl<CoachingLocalDataSource>(),
      sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<CoachingRemoteDataSource>(
    () => CoachingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CoachingLocalDataSource>(
    () => CoachingLocalDataSourceImpl(),
  );

  //! ✅ Features - Students
  sl.registerFactory(() => StudentsBloc(
        sl<CreateStudentsUseCase>(),
        sl<GetStudentsUseCase>(),
        sl<UpdateStudentsUseCase>(),
        sl<DeleteStudentsUseCase>(),
        sl<ListStudentsUseCase>(),
      ));
  sl.registerLazySingleton(() => GetStudentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateStudentsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStudentsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteStudentsUseCase(sl()));
  sl.registerLazySingleton(() => ListStudentsUseCase(sl()));
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

  //! ✅ Features - Profile
  sl.registerFactory(() => ProfileBloc(
        sl<GetProfileUseCase>(),
        sl<UpdateProfileUseCase>(),
      ));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      sl<ProfileRemoteDataSource>(),
      sl<ProfileLocalDataSource>(),
      sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(),
  );

  //! ✅ Features - Privates
  sl.registerFactory(() => PrivatesBloc(
        sl<GetPrivatesUseCase>(),
        sl<CreatedPrivatesUseCase>(),
        sl<ListPrivatesUseCase>(),
        sl<DeletedPrivatesUseCase>(),
        sl<UpdatedPrivatesUsecase>(),
      ));
  sl.registerLazySingleton(() => GetPrivatesUseCase(sl()));
  sl.registerLazySingleton(() => CreatedPrivatesUseCase(sl()));
  sl.registerLazySingleton(() => ListPrivatesUseCase(sl()));
  sl.registerLazySingleton(() => DeletedPrivatesUseCase(sl()));
  sl.registerLazySingleton(() => UpdatedPrivatesUsecase(sl()));
  sl.registerLazySingleton<PrivatesRepository>(
    () => PrivatesRepositoryImpl(
      sl<PrivatesRemoteDataSource>(),
      sl<PrivatesLocalDataSource>(),
      sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<PrivatesRemoteDataSource>(
    () => PrivatesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PrivatesLocalDataSource>(
    () => PrivatesLocalDataSourceImpl(),
  );
}
