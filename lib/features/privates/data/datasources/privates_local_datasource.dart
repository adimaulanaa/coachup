import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/services/database_service.dart';
import 'package:coachup/features/students/data/models/students_model.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class PrivatesLocalDataSource {
  Future<List<PrivatesModel>> list(String str, String fns);
  Future<List<String>> listMurid();
  Future<PrivatesModel> get(String id);
  Future<String> delete(String id);
  Future<String> create(PrivatesEntity data);
  Future<String> update(PrivatesEntity data);
}

class PrivatesLocalDataSourceImpl implements PrivatesLocalDataSource {
  final db = DatabaseService();

  @override
  Future<List<PrivatesModel>> list(String str, String fns) async {
    final database = await db.database;
    List<Map<String, dynamic>> maps;

    if (str.isNotEmpty && fns.isNotEmpty) {
      // Ambil data antara tanggal str dan fns
      maps = await database.query(
        'privates',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [str, fns],
      );
    } else {
      // Default: ambil data dari awal hingga akhir bulan berjalan
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      final startStr = DateFormat('yyyy-MM-dd').format(startOfMonth);
      final endStr = DateFormat('yyyy-MM-dd').format(endOfMonth);

      maps = await database.query(
        'privates',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [startStr, endStr],
      );
    }

    return maps.map((m) => PrivatesModel.fromMap(m)).toList();
  }

  @override
  Future<PrivatesModel> get(String id) async {
    final database = await db.database;

    // Ambil semua data murid
    final List<Map<String, dynamic>> student = await database.query('students');
    final List<StudentEntity> model =
        student.map((e) => StudentModel.fromMap(e).toEntity()).toList();

    // Ambil data private berdasarkan ID
    final maps = await database.query(
      'privates',
      where: '_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final data = PrivatesModel.fromMap(maps.first);
      final list = model.map((e) => e.name).toList();
      data.listStdn = list;
      return data;
    } else {
      throw Exception('Data private tidak ditemukan.');
    }
  }

  @override
  Future<String> create(PrivatesEntity model) async {
    final database = await db.database;

    final insert = PrivatesModel(
      id: const Uuid().v4(),
      name: model.name,
      description: model.description,
      date: model.date,
      student: model.student,
      studentId: model.studentId,
      createdOn: model.createdOn,
      updatedOn: model.updatedOn,
    );

    final int result = await database.insert(
      'privates',
      insert.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (result > 0) {
      return 'Data private berhasil disimpan.';
    } else {
      throw Exception('Gagal menyimpan data private.');
    }
  }

  @override
  Future<String> delete(String id) async {
    final database = await db.database;

    final int result = await database.delete(
      'privates',
      where: '_id = ?',
      whereArgs: [id],
    );

    if (result > 0) {
      return 'Data private berhasil dihapus.';
    } else {
      throw BadRequestException('Gagal menghapus data private.');
    }
  }

  @override
  Future<String> update(PrivatesEntity model) async {
    final database = await db.database;

    final updateModel = PrivatesModel(
      id: model.id,
      name: model.name,
      description: model.description,
      date: model.date,
      student: model.student,
      studentId: model.studentId,
      createdOn: model.createdOn,
      updatedOn: model.updatedOn,
    );

    final int result = await database.update(
      'privates',
      updateModel.toMap(),
      where: '_id = ?',
      whereArgs: [model.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (result > 0) {
      return 'Data private berhasil diperbarui.';
    } else {
      throw Exception('Gagal memperbarui data private.');
    }
  }

  @override
  Future<List<String>> listMurid() async {
    final database = await db.database;
    final List<Map<String, dynamic>> student = await database.query('students');
    final List<StudentEntity> model =
        student.map((e) => StudentModel.fromMap(e).toEntity()).toList();

    return model.map((e) => e.name).toList();
  }
}
