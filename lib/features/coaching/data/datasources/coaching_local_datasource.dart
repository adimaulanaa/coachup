import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/services/database_service.dart';
import 'package:coachup/features/students/data/models/students_model.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class CoachingLocalDataSource {
  Future<String> insertCoaching(CoachEntity model);
  Future<String> updateCoaching(CoachEntity model);
  Future<String> deleteCoaching(String id);
  Future<List<CoachEntity>> getCoaching();
  Future<List<StudentEntity>> getStudentc();
}

class CoachingLocalDataSourceImpl implements CoachingLocalDataSource {
  final db = DatabaseService();

  @override
  Future<String> insertCoaching(CoachEntity model) async {
    final database = await db.database;

    // Generate UUID jika id belum ada
    final coachModel = CoachModel(
      id: model.id.isEmpty ? const Uuid().v4() : model.id,
      name: model.name,
      topic: model.topic,
      learning: model.learning,
      date: model.date,
      timeStart: model.timeStart,
      timeFinish: model.timeFinish,
      picName: model.picName,
      picCollage: model.picCollage,
      members: model.members,
      activity: model.activity,
      description: model.description,
      createdOn: model.createdOn,
      updatedOn: model.updatedOn,
    );

    final int result = await database.insert(
      'coaches',
      coachModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (result > 0) {
      return 'Coach berhasil disimpan';
    } else {
      throw Exception('Gagal menyimpan coach');
    }
  }

  @override
  Future<List<CoachEntity>> getCoaching() async {
    final database = await db.database;
    final List<Map<String, dynamic>> maps = await database.query('coaches');
    return maps.map((e) => CoachModel.fromMap(e).toEntity()).toList();
  }

  @override
  Future<String> updateCoaching(CoachEntity model) async {
    final database = await db.database;

    final coachModel = CoachModel.fromEntity(model);

    final int result = await database.update(
      'coaches',
      coachModel.toMap(),
      where: '_id = ?',
      whereArgs: [model.id],
    );

    if (result > 0) {
      return 'Coach berhasil diperbarui';
    } else {
      throw Exception('Gagal memperbarui coach');
    }
  }

  @override
  Future<String> deleteCoaching(String id) async {
    final database = await db.database;

    final int result = await database.delete(
      'coaches',
      where: '_id = ?',
      whereArgs: [id],
    );

    if (result > 0) {
      return 'Coach berhasil dihapus';
    } else {
      throw BadRequestException('Gagal menghapus coach');
    }
  }
  
  @override
  Future<List<StudentEntity>> getStudentc() async {
    final database = await db.database;
    final List<Map<String, dynamic>> maps = await database.query('students');
    List<StudentEntity> model =
        maps.map((e) => StudentModel.fromMap(e).toEntity()).toList();
    return model;
  }
}
