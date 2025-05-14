import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';

class DashboardEntity {
  final String? name;
  final String? title;
  final int? coach;
  final int? collage;
  final int? student;
  final List<CoachEntity> coaches;

  DashboardEntity({
    this.name,
    this.title,
    this.coach,
    this.collage,
    this.student,
    this.coaches = const [],
  });
}

