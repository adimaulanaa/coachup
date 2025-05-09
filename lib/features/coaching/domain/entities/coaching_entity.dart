import 'package:equatable/equatable.dart';

class CoachingEntity extends Equatable {
  final String id;
  final String ktp;
  final String idCard;
  final String name;
  final String sak;
  final String standard;
  final bool isActive;
  final String position;
  final String status;
  final String address;
  final String contact;
  final String email;
  final String images;
  final bool isDeleted;
  final String createdOn;
  final String updatedOn;

  const CoachingEntity({
    required this.id,
    required this.ktp,
    required this.idCard,
    required this.name,
    required this.sak,
    required this.standard,
    required this.isActive,
    required this.position,
    required this.status,
    required this.address,
    required this.contact,
    required this.email,
    required this.images,
    required this.isDeleted,
    required this.createdOn,
    required this.updatedOn,
  });

  @override
  List<Object?> get props => [
        id,
        ktp,
        idCard,
        name,
        sak,
        standard,
        isActive,
        position,
        status,
        address,
        contact,
        email,
        images,
        isDeleted,
        createdOn,
        updatedOn,
      ];
}
