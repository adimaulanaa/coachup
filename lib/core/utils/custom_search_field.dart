import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const CustomSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: transTextstyle.copyWith(
          fontSize: 16,
          fontWeight: light,
          color: AppColors.bgGreySecond,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset(
            MediaRes.search,
            // ignore: deprecated_member_use
            color: AppColors.bgGreySecond,
            width: 20,
          ),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomInkWell(
                  onTap: () {
                    controller.clear();
                    onChanged('');
                    if (onClear != null) onClear!();
                  },
                  child: SvgPicture.asset(
                    MediaRes.closeCircle,
                    // ignore: deprecated_member_use
                    color: AppColors.bgGreySecond,
                    width: 20,
                  ),
                ),
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
      ),
      onChanged: onChanged,
      maxLines: 1,
      style: blackTextstyle.copyWith(
        fontSize: 16,
        fontWeight: light,
      ),
    );
  }
}
