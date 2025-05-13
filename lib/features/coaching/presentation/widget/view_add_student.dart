import 'package:flutter/material.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
class CustomSearchField extends StatefulWidget {
  final StudentEntity? value;
  final List<StudentEntity> items;
  final String label;
  final bool enabled;
  final ValueChanged<StudentEntity?>? onChanged;

  const CustomSearchField({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
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
    final outerBorderColor =
        _isFocused ? AppColors.primary.withOpacity(0.4) : Colors.transparent;
    final innerBorderColor = _isFocused ? AppColors.primary : Colors.grey;

    return Container(
      width: MediaQuery.of(context).size.width,
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
            child: DropdownMenu<StudentEntity>(
              focusNode: _focusNode,
              hintText: widget.label,
              enabled: widget.enabled,
              enableSearch: true,
              enableFilter: true,
              requestFocusOnTap: true,
              menuHeight: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.81,
              dropdownMenuEntries: widget.items
                  .map(
                    (e) => DropdownMenuEntry<StudentEntity>(
                      value: e,
                      label: e.name,
                    ),
                  )
                  .toList(),
              textStyle: blackTextstyle.copyWith(fontSize: 15, fontWeight: medium),
              inputDecorationTheme: InputDecorationTheme(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                labelStyle: transTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: medium,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
              onSelected: (val) {
                FocusManager.instance.primaryFocus?.unfocus();
                if (widget.onChanged != null) {
                  widget.onChanged!(widget.items.isNotEmpty ? val : null);
                }
              },
              searchCallback: (entries, query) {
                if (query.isEmpty) {
                  return null;
                }
                final int index = entries.indexWhere(
                  (entry) => entry.label.toLowerCase().contains(query.toLowerCase()),
                );
                return index != -1 ? index : null;
              },
            ),
          ),
        ),
      ),
    );
  }
}
