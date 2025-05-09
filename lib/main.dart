import 'package:coachup/core/di/injection_container.dart' as di;
import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:coachup/features/onboarding/onboarding.dart';
import 'package:coachup/features/students/presentation/bloc/students_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // ✅ Inisialisasi dependency injection
  // runApp(const MyApp());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<DashboardBloc>()),
        BlocProvider(create: (_) => di.sl<StudentsBloc>()),
        // Tambahkan Bloc lain di sini kalau perlu
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins', // Mengatur font default untuk aplikasi
      ),
      navigatorKey: AppNavigator.navigatorKey,
      title: StringResources.nameApp,
      debugShowCheckedModeBanner: false,
      home: const Onboarding(),
    );
  }
}
