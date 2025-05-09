import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final double margin;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.label,
    this.margin = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 57,
        margin: EdgeInsets.only(right: margin, left: margin),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(11),
          color: AppColors.primary.withOpacity(0.8),
        ),
        child: Center(
          child: Text(
            label,
            style: whiteTextstyle.copyWith(
              fontSize: 15,
              fontWeight: bold,
            ),
          ),
        ),
      ),
    );
  }
}
