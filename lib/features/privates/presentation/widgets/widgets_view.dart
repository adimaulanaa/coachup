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
