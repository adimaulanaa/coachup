import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:flutter/material.dart';

class GenderButton extends StatelessWidget {
  final String gender;
  final String selectedGender;
  final bool enabled;
  final Function(String) onSelect;

  const GenderButton({
    super.key,
    required this.gender,
    required this.selectedGender,
    required this.onSelect, 
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => onSelect(gender),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: blackTextstyle.copyWith(
              fontSize: 15,
              fontWeight: medium,
            ),
          ),
        ),
      ),
    );
  }
}
