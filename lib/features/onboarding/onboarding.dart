import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/utils/ui_mode_helper.dart';
import 'package:coachup/features/navbar_screen.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
    UiModeHelper.enableImmersive();
    // Panggil fungsi tanpa `await` langsung
    _navigateAfterOnboarding();
  }

  void _navigateAfterOnboarding() {
    Future.delayed(const Duration(seconds: 4), () {
      navToDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: Image.asset(
          MediaRes.omboarding, // Ganti dengan path gambar Anda
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.21,
          fit: BoxFit.cover,
        ),
        // child: Text(
        //   'Coach Up',
        //   style: blackTextstyle.copyWith(
        //     fontSize: 35,
        //     fontWeight: bold,
        //   ),
        // ),
      ),
    );
  }

  Future<dynamic> navToDashboard() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const NavbarScreen(),
      ),
    );
  }
}
