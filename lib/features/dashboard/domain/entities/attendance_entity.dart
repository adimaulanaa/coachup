class AttendanceEntity {
  final String id;
  final String idEmployee;
  final String name;
  final String type;
  final String? notes;
  final String? distance;
  final String? longitude;
  final String? latitude;
  final String? overdue;
  final String createdOn;
  final String updatedOn;

  AttendanceEntity({
    required this.id,
    required this.idEmployee,
    required this.name,
    required this.type,
    this.notes,
    this.distance,
    this.longitude,
    this.latitude,
    this.overdue,
    required this.createdOn,
    required this.updatedOn,
  });
}


class AttendanceInOutEntity {
  final String employee;
  final String id;
  final double latitude;
  final double longitude;

  AttendanceInOutEntity({
    required this.employee,
    required this.id,
    required this.latitude,
    required this.longitude,
  });
}
