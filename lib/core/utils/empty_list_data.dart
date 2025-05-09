import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyListData extends StatelessWidget {
  final Size size;
  final String message;
  const EmptyListData({super.key, required this.size, required this.message,});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          children: [
            SvgPicture.asset(
              MediaRes.warning,
              // ignore: deprecated_member_use
              color: AppColors.bgGreySecond,
              width: size.width * 0.4,
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              message,
              style: blackTextstyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyReport extends StatelessWidget {
  final Size size;
  const EmptyReport({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          children: [
            SvgPicture.asset(
              MediaRes.warning,
              // ignore: deprecated_member_use
              color: AppColors.bgGreySecond,
              width: size.width * 0.4,
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              'Tidak ada data report',
              style: blackTextstyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectDateFilterReport extends StatelessWidget {
  final Size size;
  const SelectDateFilterReport({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          children: [
            SvgPicture.asset(
              MediaRes.warning,
              // ignore: deprecated_member_use
              color: AppColors.bgGreySecond,
              width: size.width * 0.4,
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              'Pilih tanggal report untuk melihat data report',
              textAlign: TextAlign.center,
              style: blackTextstyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
