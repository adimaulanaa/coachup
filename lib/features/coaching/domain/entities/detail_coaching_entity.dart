import 'package:coachup/features/students/domain/entities/students_entity.dart';

class DetailCoachingEntity {
  final String? id;
  final String? name;
  final String? topic;
  final String? learning;
  final String? date;
  final String? timeStart;
  final String? timeFinish;
  final String? picName;
  final String? picCollage;
  final List<StudentEntity> members;
  final List<StudentEntity> allStudent;
  final String? activity;
  final String? description;
  final String? createdOn;
  final String? updatedOn;

  DetailCoachingEntity({
    this.id,
    this.name,
    this.topic,
    this.learning,
    this.date,
    this.timeStart,
    this.timeFinish,
    this.picName,
    this.picCollage,
    this.members = const [],
    this.allStudent = const [],
    this.activity,
    this.description,
    this.createdOn,
    this.updatedOn,
  });
}
