import 'package:coachup/features/students/domain/entities/students_entity.dart';

class StudentModel extends StudentEntity {
  StudentModel({
    required super.id,
    required super.name,
    required super.studentClass,
    required super.gender,
    required super.collage,
    required super.phone,
    required super.active,
    required super.createdOn,
    required super.updatedOn,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      studentClass: map['class'] ?? '',
      gender: map['gender'] ?? '',
      collage: map['collage'] ?? '',
      phone: map['tlpn'] ?? '',
      active: map['active'] ?? '',
      createdOn: map['created_on'] ?? '',
      updatedOn: map['updated_on'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'class': studentClass,
      'gender': gender,
      'collage': collage,
      'tlpn': phone,
      'active': active,
      'created_on': createdOn,
      'updated_on': updatedOn,
    };
  }

  /// Convert from entity to model
  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      name: entity.name,
      studentClass: entity.studentClass,
      gender: entity.gender,
      collage: entity.collage,
      phone: entity.phone,
      active: entity.active,
      createdOn: entity.createdOn,
      updatedOn: entity.updatedOn,
    );
  }

  /// Convert from model to entity
  StudentEntity toEntity() {
    return StudentEntity(
      id: id,
      name: name,
      studentClass: studentClass,
      gender: gender,
      collage: collage,
      phone: phone,
      active: active,
      createdOn: createdOn,
      updatedOn: updatedOn,
    );
  }
}
