
import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';

class DashboardEntity {
  final String? name;
  final String? title;
  final List<CoachModel> coach;
  final List<PrivatesModel> private;

  DashboardEntity({
    this.name,
    this.title,
    this.coach = const [],
    this.private = const [],
  });
}

