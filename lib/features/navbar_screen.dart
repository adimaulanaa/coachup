import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/features/coaching/presentation/pages/coaching_page.dart';
import 'package:coachup/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:coachup/features/students/presentation/pages/students_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    CoachingPage(),
    StudentsPage(),
    Container(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: AppColors.bgGrey,
        ),
        child: SizedBox(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, MediaRes.dashboard, 25),
              _navItem(1, MediaRes.employee, 25),
              _navItem(2, MediaRes.report, 25),
              _navItem(3, MediaRes.profile, 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, String iconPath, double sizeIcons) {
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 3),
              SvgPicture.asset(
                iconPath,
                width: sizeIcons,
                // ignore: deprecated_member_use
                color: isSelected ? AppColors.primary : AppColors.bgBlack,
              ),
              const SizedBox(height: 8),
              if (isSelected)
                SvgPicture.asset(
                  MediaRes.indicatorNav,
                  fit: BoxFit.contain,
                  height: 7,
                  width: 30,
                  // ignore: deprecated_member_use
                  color: AppColors.primary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
