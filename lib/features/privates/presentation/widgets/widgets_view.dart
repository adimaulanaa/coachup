import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/formater_datetime.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

class ViweListPrivate extends StatelessWidget {
  final PrivatesEntity dt;
  final Size size;
  const ViweListPrivate({
    super.key,
    required this.dt,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    List<String> list = dt.student
            ?.split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
    final tgl = formatDateManual(dt.date.toString());
    int total = list.length;
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dt.name.toString(),
            style: blackTextstyle.copyWith(
              fontSize: 13,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Deskripsi : ${dt.description}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: blackTextstyle.copyWith(
              fontSize: 13,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    MediaRes.student,
                    // ignore: deprecated_member_use
                    color: AppColors.primary,
                    width: 20,
                  ),
                  SizedBox(width: 5),
                  Text(
                    total.toString(),
                    style: blackTextstyle.copyWith(
                      fontSize: 12,
                      fontWeight: bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Murid',
                    style: blackTextstyle.copyWith(
                      fontSize: 12,
                      fontWeight: reguler,
                    ),
                  ),
                ],
              ),
              Text(
                tgl,
                style: blackTextstyle.copyWith(
                  fontSize: 11,
                  fontWeight: reguler,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SmoothCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final bool enabled;
  final Color activeColor;
  final Color borderColor;
  final double size;

  const SmoothCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.enabled = true,
    this.activeColor = AppColors.primary,
    this.borderColor = AppColors.bgGreySecond,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => onChanged(!value) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: value ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? activeColor : borderColor,
                width: 2,
              ),
            ),
            child: value
                ? Icon(
                    Icons.check,
                    size: size * 0.7,
                    color: AppColors.bgColor,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              style: transTextstyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
                color: value ? AppColors.bgBlack : borderColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomSearchStringField extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String label;
  final bool enabled;
  final ValueChanged<String?>? onChanged;

  const CustomSearchStringField({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<CustomSearchStringField> createState() => _CustomSearchStringFieldState();
}

class _CustomSearchStringFieldState extends State<CustomSearchStringField> {
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
            child: DropdownMenu<String>(
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
                    (e) => DropdownMenuEntry<String>(
                      value: e,
                      label: e,
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
                  widget.onChanged!(val);
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
