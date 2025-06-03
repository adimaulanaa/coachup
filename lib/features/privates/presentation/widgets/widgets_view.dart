import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
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

Widget viewSelectedType(String text, int type) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
          width: 2.5,
        ),
        borderRadius: type == 1
            ? BorderRadius.only(
                topLeft: Radius.circular(11),
                bottomLeft: Radius.circular(11),
              )
            : type == 2
                ? BorderRadius.only(
                    topRight: Radius.circular(11),
                    bottomRight: Radius.circular(11),
                  )
                : null,
      ),
      child: Center(
        child: Text(
          text,
          style: blackTextstyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
        ),
      ),
    );
  }