
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';

class CoachModel extends CoachEntity {
  CoachModel({
    required super.id,
    required super.name,
    required super.topic,
    required super.learning,
    required super.date,
    required super.timeStart,
    required super.timeFinish,
    required super.picName,
    required super.picCollage,
    required super.members,
    required super.activity,
    required super.description,
    required super.createdOn,
    required super.updatedOn,
  });

  factory CoachModel.fromMap(Map<String, dynamic> map) {
    return CoachModel(
      id: map['_id'],
      name: map['name'],
      topic: map['topic'],
      learning: map['learning'],
      date: map['date'],
      timeStart: map['time_start'],
      timeFinish: map['time_finish'],
      picName: map['pic_name'],
      picCollage: map['pic_collage'],
      members: map['members'],
      activity: map['activity'],
      description: map['description'],
      createdOn: map['created_on'],
      updatedOn: map['updated_on'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'topic': topic,
      'learning': learning,
      'date': date,
      'time_start': timeStart,
      'time_finish': timeFinish,
      'pic_name': picName,
      'pic_collage': picCollage,
      'members': members,
      'activity': activity,
      'description': description,
      'created_on': createdOn,
      'updated_on': updatedOn,
    };
  }

  CoachEntity toEntity() {
    return CoachEntity(
      id: id,
      name: name,
      topic: topic,
      learning: learning,
      date: date,
      timeStart: timeStart,
      timeFinish: timeFinish,
      picName: picName,
      picCollage: picCollage,
      members: members,
      activity: activity,
      description: description,
      createdOn: createdOn,
      updatedOn: updatedOn,
    );
  }

  static CoachModel fromEntity(CoachEntity entity) {
    return CoachModel(
      id: entity.id,
      name: entity.name,
      topic: entity.topic,
      learning: entity.learning,
      date: entity.date,
      timeStart: entity.timeStart,
      timeFinish: entity.timeFinish,
      picName: entity.picName,
      picCollage: entity.picCollage,
      members: entity.members,
      activity: entity.activity,
      description: entity.description,
      createdOn: entity.createdOn,
      updatedOn: entity.updatedOn,
    );
  }
}
