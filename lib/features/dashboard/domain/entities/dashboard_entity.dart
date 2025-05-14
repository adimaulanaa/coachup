import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';

class DashboardEntity {
  final int? coach;
  final int? collage;
  final int? student;
  final List<CoachEntity> coaches;

  DashboardEntity({
    this.coach,
    this.collage,
    this.student,
    this.coaches = const [],
  });
}

