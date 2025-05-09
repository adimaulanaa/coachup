class StudentEntity {
  final String id;
  final String name;
  final String studentClass;
  final String gender;
  final String collage;
  final String phone;
  final String active;
  final String createdOn;
  final String updatedOn;

  StudentEntity({
    required this.id,
    required this.name,
    required this.studentClass,
    required this.gender,
    required this.collage,
    required this.phone,
    required this.active,
    required this.createdOn,
    required this.updatedOn,
  });

  StudentEntity copyWith({
    String? id,
    String? name,
    String? studentClass,
    String? gender,
    String? collage,
    String? phone,
    String? active,
    String? createdOn,
    String? updatedOn,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      studentClass: studentClass ?? this.studentClass,
      gender: gender ?? this.gender,
      collage: collage ?? this.collage,
      phone: phone ?? this.phone,
      active: active ?? this.active,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }
}
