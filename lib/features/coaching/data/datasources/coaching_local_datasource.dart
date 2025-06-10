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
  Future<List<CoachModel>> listCoaching(String str, String fns) async {
    final database = await db.database;
    // final List<Map<String, dynamic>> maps = await database.query('coaches');
    List<Map<String, dynamic>> maps;
    if (str.isNotEmpty && fns.isNotEmpty) {
      // Ambil data di antara str dan fns
      maps = await database.query(
        'coaches',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [str, fns],
      );
    } else {
      // Ambil data 30 hari terakhir
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
    final result = maps.map((m) => CoachModel.fromMap(m)).toList();
    return result;
  }

  @override
  Future<CoachEntity> getCoaching(String id) async {
    final database = await db.database;
    final List<Map<String, dynamic>> maps = await database.query(
      'coaches',
      where: '_id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw ServerException('Coach tidak ditemukan');
    }
    final coachModel = CoachModel.fromMap(maps.first);
    return coachModel;
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

  @override
  Future<DetailCoachingEntity> detailCoaching(String id) async {
    final database = await db.database;

    final List<Map<String, dynamic>> coachMaps = await database.query(
      'coaches',
      where: '_id = ?',
      whereArgs: [id],
    );

    // student
    final List<Map<String, dynamic>> maps = await database.query('students');
    List<StudentEntity> modelStudent =
        maps.map((e) => StudentModel.fromMap(e).toEntity()).toList();

    if (coachMaps.isNotEmpty) {
      final map = coachMaps.first;

      // Konversi field 'members' (comma-separated) menjadi List<String>
      final List<String> idList = (map['members'] as String)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Filter student yang ID-nya ada di idList
      final List<StudentEntity> selectedMembers =
          modelStudent.where((student) => idList.contains(student.id)).toList();

      // Sesuaikan ini dengan field yang kamu punya di tabel "coaches"
      final model = DetailCoachingEntity(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        topic: map['topic'] ?? '',
        learning: map['learning'] ?? '',
        date: map['date'] ?? '',
        timeStart: map['time_start'] ?? '',
        timeFinish: map['time_finish'] ?? '',
        picName: map['pic_name'] ?? '',
        picCollage: map['pic_collage'] ?? '',
        members: selectedMembers,
        allStudent: modelStudent,
        activity: map['activity'] ?? '',
        description: map['description'] ?? '',
        createdOn: map['created_on'] ?? '',
        updatedOn: map['updated_on'] ?? '',
      );
      return model;
    } else {
      // Handle jika data tidak ditemukan
      throw Exception('Data not found');
    }
  }
}
