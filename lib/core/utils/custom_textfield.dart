import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan warna border berdasarkan fokus
    final Color outerBorderColor =
        _isFocused ? AppColors.primary.withOpacity(0.4) : Colors.transparent;

    final Color innerBorderColor = _isFocused ? AppColors.primary : Colors.grey;

    final Color labelColor = _isFocused ? Colors.black : Colors.grey;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: outerBorderColor,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(11),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: innerBorderColor,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              style: blackTextstyle.copyWith(
                fontSize: 15,
                fontWeight: medium,
                // color: labelColor,
              ),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: transTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: medium,
                  color: labelColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
