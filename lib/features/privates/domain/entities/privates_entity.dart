
class PrivatesEntity {
  final String? id;
  final String? name;
  final String? description;
  final String? date;
  final String? student;
  final String? studentId;
  List<String> listStdn;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  PrivatesEntity({
    this.id,
    this.name,
    this.description,
    this.date,
    this.student,
    this.studentId,
    this.listStdn = const [],
    this.createdOn, 
    this.updatedOn, 
  });
}

