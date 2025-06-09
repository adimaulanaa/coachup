import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectedTypeView extends StatelessWidget {
  final String text;
  final int type;
  final String iconPath; // Path SVG Icon
  final Color iconColor;
  final double widthIc;

  const SelectedTypeView({
    super.key,
    required this.text,
    required this.type,
    required this.iconPath,
    this.iconColor = AppColors.primary,
    this.widthIc = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
          width: 2.5,
        ),
        borderRadius: type == 1
            ? const BorderRadius.only(
                topLeft: Radius.circular(11),
                bottomLeft: Radius.circular(11),
              )
            : type == 2
                ? const BorderRadius.only(
                    topRight: Radius.circular(11),
                    bottomRight: Radius.circular(11),
                  )
                : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            // ignore: deprecated_member_use
            color: iconColor,
            width: widthIc,
            height: widthIc,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: blackTextstyle.copyWith(
              fontSize: 13,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
}
