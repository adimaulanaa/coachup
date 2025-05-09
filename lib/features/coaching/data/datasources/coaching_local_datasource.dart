import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class CoachingLocalDataSource {
  Future<String> insertCoaching(CoachingEntity model);
  Future<String> updateCoaching(CoachingEntity model);
  Future<String> deleteCoaching(String id);
  Future<List<CoachingEntity>> getCoachings();
}

class CoachingLocalDataSourceImpl implements CoachingLocalDataSource {
  final db = DatabaseService();

  @override
  Future<String> insertCoaching(CoachingEntity model) async {
    final database = await db.database;
    final models = CoachingModel(
      id: const Uuid().v4(),
      ktp: model.ktp,
      idCard: model.idCard,
      name: model.name,
      sak: model.sak,
      standard: model.standard,
      isActive: model.isActive,
      position: model.position,
      status: model.status,
      address: model.address,
      contact: model.contact,
      email: model.email,
      images: model.images,
      isDeleted: model.isDeleted,
      createdOn: model.createdOn,
      updatedOn: model.updatedOn,
    );

    final int rowId = await database.insert(
      'coaching',
      models.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (rowId > 0) {
      return 'Coaching berhasil disimpan';
    } else {
      throw BadRequestException('Failed to insert coaching');
    }
  }

  @override
  Future<List<CoachingEntity>> getCoachings() async {
    // final database = await db.database;
    // final List<Map<String, dynamic>> maps = await database.query('coaching');

    // return maps.map((e) => CoachingModel.fromJson(e)).toList();
    return [];
  }

  @override
  Future<String> updateCoaching(CoachingEntity model) async {
    final database = await db.database;
    final models = CoachingModel(
      id: model.id, // gunakan ID yang sudah ada
      ktp: model.ktp,
      idCard: model.idCard,
      name: model.name,
      sak: model.sak,
      standard: model.standard,
      isActive: model.isActive,
      position: model.position,
      status: model.status,
      address: model.address,
      contact: model.contact,
      email: model.email,
      images: model.images,
      isDeleted: model.isDeleted,
      createdOn: model.createdOn,
      updatedOn: model.updatedOn,
    );

    await database.update(
      'coaching',
      models.toMap(),
      where: '_id = ?',
      whereArgs: [model.id],
    );
    return 'Coaching updated successfully';
  }

  @override
  Future<String> deleteCoaching(String id) async {
    final database = await db.database;
    // Cek apakah ada data dengan _id yang sama di tabel attendance
    final List<Map<String, dynamic>> attendanceCheck = await database.query(
      'attendance',
      where: 'id_coaching = ?',
      whereArgs: [id], // Cek berdasarkan _id
    );

    if (attendanceCheck.isNotEmpty) {
      // Jika data ditemukan di attendance, batalkan penghapusan dan beri pesan error
      throw BadRequestException(
          'Coaching tidak dapat dihapus karena ada data dalam tabel attendance.');
    }
    final int rowId = await database.delete(
      'coaching',
      where: '_id = ?',
      whereArgs: [id], // Hapus berdasarkan _id
    );
    if (rowId > 0) {
      return 'Coaching deleted successfully';
    } else {
      throw BadRequestException('Failed to delete coaching.');
    }
  }
}
