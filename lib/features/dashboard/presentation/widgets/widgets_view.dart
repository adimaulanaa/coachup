import 'package:coachup/core/media/media_colors.dart';
import 'package:flutter/material.dart';

class BuildBoxAttendance extends StatefulWidget {
  final bool type;
  final Size size;
  const BuildBoxAttendance({
    super.key,
    required this.size,
    required this.type,
  });

  @override
  State<BuildBoxAttendance> createState() => _BuildBoxAttendanceState();
}

class _BuildBoxAttendanceState extends State<BuildBoxAttendance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.1,
      width: widget.size.width * 0.45,
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(widget.type ? 'CheckIn' : 'CheckOut')),
    );
  }
}