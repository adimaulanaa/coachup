import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListCoaching extends StatelessWidget {
  final CoachEntity dt;
  final Size size;
  const ListCoaching({
    super.key,
    required this.dt,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(dt.date);
    String formattedDate = DateFormat('d MMMM yyyy').format(parsedDate);
    int member = 0;
    if (dt.members != '') {
      member = dt.members.split(',').length;
    }
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dt.picCollage,
                  style: blackTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$formattedDate, ${dt.timeStart} - ${dt.timeFinish}',
                  style: blackTextstyle.copyWith(
                    fontSize: 13,
                    fontWeight: medium,
                  ),
                ),
                Text(
                  dt.topic,
                  style: blackTextstyle.copyWith(
                    fontSize: 13,
                    fontWeight: medium,
                  ),
                ),
                Text(
                  'Member : $member murid',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
