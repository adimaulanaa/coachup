import 'package:coachup/features/privates/domain/entities/privates_entity.dart';

class PrivatesModel extends PrivatesEntity {
  PrivatesModel({
    super.id,
    super.name,
    super.description,
    super.date,
    super.student,
    super.studentId,
    super.createdOn,
    super.updatedOn,
  });

  /// JSON from API
  factory PrivatesModel.fromJson(Map<String, dynamic> json) => PrivatesModel(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        date: json['date'] as String?,
        student: json['student'] as String?,
        studentId: json['student_id'] as String?,
        createdOn: json['createdOn'] != null
            ? DateTime.parse(json['createdOn'])
            : null,
        updatedOn: json['created_on'] != null
            ? DateTime.parse(json['updated_on'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'date': date,
        'student': student,
        'student_id': studentId,
        'created_on': createdOn?.toIso8601String(),
        'updated_on': updatedOn?.toIso8601String(),
      };

  /// from local or generic Map (e.g., from SQLite or shared preferences)
  factory PrivatesModel.fromMap(Map<String, dynamic> map) => PrivatesModel(
        id: map['_id'] as String?,
        name: map['name'] as String?,
        description: map['description'] as String?,
        date: map['date'] as String?,
        student: map['student'] as String?,
        studentId: map['student_id'] as String?, // ✅ snake_case
        createdOn: map['created_on'] != null
            ? DateTime.parse(map['created_on'])
            : null, // ✅ snake_case
        updatedOn: map['updated_on'] != null
            ? DateTime.parse(map['updated_on'])
            : null, // ✅ snake_case
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'name': name,
        'description': description,
        'date': date,
        'student': studentId,
        'student_id': studentId,
        'created_on': createdOn?.toIso8601String(),
        'updated_on': updatedOn?.toIso8601String(),
      };

  /// convert from entity
  factory PrivatesModel.fromEntity(PrivatesEntity entity) => PrivatesModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        date: entity.date,
        student: entity.student,
        studentId: entity.studentId,
        createdOn: entity.createdOn,
        updatedOn: entity.updatedOn,
      );

  /// convert to entity
  PrivatesEntity toEntity() => PrivatesEntity(
        id: id,
        name: name,
        description: description,
        date: date,
        student: student,
        studentId: studentId,
        createdOn: createdOn,
        updatedOn: updatedOn,
      );
}
