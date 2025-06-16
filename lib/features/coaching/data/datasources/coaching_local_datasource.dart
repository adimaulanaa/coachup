import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/domain/entities/detail_coaching_entity.dart';
import 'package:coachup/features/services/database_service.dart';
import 'package:coachup/features/students/data/models/students_model.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class CoachingLocalDataSource {
  Future<String> insertCoaching(CoachEntity model);
  Future<String> updateCoaching(CoachEntity model);
  Future<String> deleteCoaching(String id);
  Future<List<CoachModel>> listCoaching(String str, String fns);
  Future<CoachEntity> getCoaching(String id);
  Future<List<StudentEntity>> getStudentc();
  Future<DetailCoachingEntity> detailCoaching(String id);
}

class CoachingLocalDataSourceImpl implements CoachingLocalDataSource {
  final db = DatabaseService();

  @override
  Future<String> insertCoaching(CoachEntity model) async {
    final database = await db.database;

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
      return 'Pelatihan berhasil disimpan.';
    } else {
      throw Exception('Gagal menyimpan pelatihan.');
    }
  }

  @override
  Future<List<CoachModel>> listCoaching(String str, String fns) async {
    final database = await db.database;
    List<Map<String, dynamic>> maps;

    if (str.isNotEmpty && fns.isNotEmpty) {
      maps = await database.query(
        'coaches',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [str, fns],
      );
    } else {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      final startStr = DateFormat('yyyy-MM-dd').format(startOfMonth);
      final endStr = DateFormat('yyyy-MM-dd').format(endOfMonth);

      maps = await database.query(
        'coaches',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [startStr, endStr],
      );
    }

    return maps.map((m) => CoachModel.fromMap(m)).toList();
  }

  @override
  Future<CoachEntity> getCoaching(String id) async {
    final database = await db.database;

    final maps = await database.query(
      'coaches',
      where: '_id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw ServerException('Pelatihan tidak ditemukan.');
    }

    return CoachModel.fromMap(maps.first);
  }

  @override
  Future<String> updateCoaching(CoachEntity model) async {
    final database = await db.database;

    final coachModel = CoachModel.fromEntity(model);

    final result = await database.update(
      'coaches',
      coachModel.toMap(),
      where: '_id = ?',
      whereArgs: [model.id],
    );

    if (result > 0) {
      return 'Pelatihan berhasil diperbarui.';
    } else {
      throw Exception('Gagal memperbarui pelatihan.');
    }
  }

  @override
  Future<String> deleteCoaching(String id) async {
    final database = await db.database;

    final result = await database.delete(
      'coaches',
      where: '_id = ?',
      whereArgs: [id],
    );

    if (result > 0) {
      return 'Pelatihan berhasil dihapus.';
    } else {
      throw BadRequestException('Gagal menghapus pelatihan.');
    }
  }

  @override
  Future<List<StudentEntity>> getStudentc() async {
    final database = await db.database;

    final maps = await database.query('students');

    return maps.map((e) => StudentModel.fromMap(e).toEntity()).toList();
  }

  @override
  Future<DetailCoachingEntity> detailCoaching(String id) async {
    final database = await db.database;

    final coachMaps = await database.query(
      'coaches',
      where: '_id = ?',
      whereArgs: [id],
    );

    final studentMaps = await database.query('students');
    final modelStudent =
        studentMaps.map((e) => StudentModel.fromMap(e).toEntity()).toList();

    if (coachMaps.isEmpty) {
      throw Exception('Data pelatihan tidak ditemukan.');
    }

    final map = coachMaps.first;
    final membersRaw = map['members'] as String? ?? '';

    final idList = membersRaw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final selectedMembers =
        modelStudent.where((student) => idList.contains(student.id)).toList();

    // Sesuaikan ini dengan field yang kamu punya di tabel "coaches"
    return DetailCoachingEntity(
      id: map['_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      topic: map['topic'] as String? ?? '',
      learning: map['learning'] as String? ?? '',
      date: map['date'] as String? ?? '',
      timeStart: map['time_start'] as String? ?? '',
      timeFinish: map['time_finish'] as String? ?? '',
      picName: map['pic_name'] as String? ?? '',
      picCollage: map['pic_collage'] as String? ?? '',
      activity: map['activity'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdOn: map['created_on'] as String? ?? '',
      updatedOn: map['updated_on'] as String? ?? '',
      members: selectedMembers,
      allStudent: modelStudent,
    );
  }
}
