import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focus;
  final String label;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isDescription;
  final int lines;

  const CustomTextField({
    super.key,
    required this.controller,
    this.focus,
    required this.label,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.isDescription = false,
    this.lines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _internalFocusNode;
  bool _isFocused = false;

  FocusNode get _effectiveFocusNode => widget.focus ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();

    _internalFocusNode = FocusNode();

    _effectiveFocusNode.addListener(() {
      setState(() {
        _isFocused = _effectiveFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focus == null) {
      _internalFocusNode.dispose();
    }
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
              focusNode: _internalFocusNode,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              style: blackTextstyle.copyWith(
                fontSize: 15,
                fontWeight: medium,
                // color: labelColor,
              ),
              maxLines: widget.isDescription ? widget.lines : 1,
              minLines: widget.isDescription ? widget.lines : 1,
              keyboardType: widget.isDescription
                  ? TextInputType.multiline
                  : TextInputType.text,
              textInputAction: widget.isDescription
                  ? TextInputAction.newline
                  : TextInputAction.done,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: transTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: medium,
                  color: labelColor,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final Function(DateTime date)? onDatePicked; // ← Tambahan

  const CustomDateField({
    super.key,
    required this.controller,
    required this.label,
    this.enabled = true,
    this.onDatePicked, // ← Tambahan
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
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

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.controller.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      widget.controller.text = formattedDate;

      if (widget.onDatePicked != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onDatePicked!(picked);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color outerBorderColor =
        _isFocused ? AppColors.primary.withOpacity(0.4) : Colors.transparent;
    final Color innerBorderColor = _isFocused ? AppColors.primary : Colors.grey;
    final Color labelColor = _isFocused ? Colors.black : Colors.grey;

    return GestureDetector(
      onTap: widget.enabled ? _pickDate : null,
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: outerBorderColor, width: 3),
            borderRadius: BorderRadius.circular(11),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: innerBorderColor, width: 2.5),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: false,
                  style:
                      blackTextstyle.copyWith(fontSize: 15, fontWeight: medium),
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
        ),
      ),
    );
  }
}

class CustomTimeField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;

  const CustomTimeField({
    super.key,
    required this.controller,
    required this.label,
    this.enabled = true,
  });

  @override
  State<CustomTimeField> createState() => _CustomTimeFieldState();
}

class _CustomTimeFieldState extends State<CustomTimeField> {
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

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // ignore: use_build_context_synchronously
      final formattedTime = picked.format(context); // misal: 10:30 AM
      widget.controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color outerBorderColor =
        _isFocused ? AppColors.primary.withOpacity(0.4) : Colors.transparent;
    final Color innerBorderColor = _isFocused ? AppColors.primary : Colors.grey;
    final Color labelColor = _isFocused ? Colors.black : Colors.grey;

    return GestureDetector(
      onTap: widget.enabled ? _pickTime : null,
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: outerBorderColor, width: 3),
            borderRadius: BorderRadius.circular(11),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: innerBorderColor, width: 2.5),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: false,
                  style:
                      blackTextstyle.copyWith(fontSize: 15, fontWeight: medium),
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
        ),
      ),
    );
  }
}

class CustomTextStudentField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focus;
  final String label;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isDescription;
  final int lines;

  const CustomTextStudentField({
    super.key,
    required this.controller,
    this.focus,
    required this.label,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.isDescription = false,
    this.lines = 1,
  });

  @override
  State<CustomTextStudentField> createState() => _CustomTextStudentFieldState();
}

class _CustomTextStudentFieldState extends State<CustomTextStudentField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    // Gunakan FocusNode dari luar jika ada, jika tidak buat baru
    _focusNode = widget.focus ?? FocusNode();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    // Hanya dispose jika kita yang buat sendiri
    if (widget.focus == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onFieldSubmitted: widget.onSubmitted,
              style: blackTextstyle.copyWith(
                fontSize: 15,
                fontWeight: medium,
              ),
              maxLines: widget.isDescription ? widget.lines : 1,
              minLines: widget.isDescription ? widget.lines : 1,
              keyboardType: widget.isDescription
                  ? TextInputType.multiline
                  : TextInputType.text,
              textInputAction: widget.isDescription
                  ? TextInputAction.newline
                  : TextInputAction.done,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: transTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: medium,
                  color: labelColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
