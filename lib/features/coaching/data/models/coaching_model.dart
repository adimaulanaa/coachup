import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';

class CoachingModel extends CoachingEntity {
  const CoachingModel({
    required super.id,
    required super.idCard,
    required super.ktp,
    required super.name,
    required super.sak,
    required super.standard,
    required super.isActive,
    required super.position,
    required super.status,
    required super.address,
    required super.contact,
    required super.email,
    required super.images,
    required super.isDeleted,
    required super.createdOn,
    required super.updatedOn,
  });

  factory CoachingModel.fromJson(Map<String, dynamic> json) {
    return CoachingModel(
      id: json['_id'],
      ktp: json['ktp'],
      idCard: json['id_card'],
      name: json['name'],
      sak: json['sak'],
      standard: json['standard'],
      isActive: json['is_active'] == 'true',
      position: json['position'],
      status: json['status'],
      address: json['address'],
      contact: json['contact'],
      email: json['email'],
      images: json['images'],
      isDeleted: json['is_deleted'] == 'true',
      createdOn: json['created_on'],
      updatedOn: json['updated_on'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'ktp': ktp,
      'id_card': idCard,
      'name': name,
      'sak': sak,
      'standard': standard,
      'is_active': isActive.toString(), // simpan sebagai string "true"/"false"
      'position': position,
      'status': status,
      'address': address,
      'contact': contact,
      'email': email,
      'images': images,
      'is_deleted': isDeleted.toString(), // simpan sebagai string juga
      'created_on': createdOn,
      'updated_on': updatedOn,
    };
  }
}
