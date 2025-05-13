import 'package:coachup/features/coaching/domain/entities/member_entity.dart';

class MemberModel extends MemberEntity {
  MemberModel({
    required super.id,
    required super.coachId,
    required super.studentId,
    required super.name,
    required super.studentClass,
    required super.ttd,
    required super.createdOn,
  });

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['_id'],
      coachId: map['coach_id'],
      studentId: map['student_id'],
      name: map['name'],
      studentClass: map['class'],
      ttd: map['ttd'],
      createdOn: map['created_on'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'coach_id': coachId,
      'student_id': studentId,
      'name': name,
      'class': studentClass,
      'ttd': ttd,
      'created_on': createdOn,
    };
  }

  MemberEntity toEntity() {
    return MemberEntity(
      id: id,
      coachId: coachId,
      studentId: studentId,
      name: name,
      studentClass: studentClass,
      ttd: ttd,
      createdOn: createdOn,
    );
  }

  static MemberModel fromEntity(MemberEntity entity) {
    return MemberModel(
      id: entity.id,
      coachId: entity.coachId,
      studentId: entity.studentId,
      name: entity.name,
      studentClass: entity.studentClass,
      ttd: entity.ttd,
      createdOn: entity.createdOn,
    );
  }
}
