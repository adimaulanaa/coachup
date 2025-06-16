import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/features/students/data/models/students_model.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:coachup/features/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class StudentsLocalDataSource {
  Future<String> insertStudents(StudentEntity model);
  Future<String> updateStudents(StudentEntity model);
  Future<String> deleteStudents(String id);
  Future<List<StudentEntity>> list();
  Future<StudentEntity> get(String id);
}

class StudentsLocalDataSourceImpl implements StudentsLocalDataSource {
  final db = DatabaseService();

  @override
  Future<String> insertStudents(StudentEntity model) async {
    final database = await db.database;
    final studentModel = StudentModel(
      id: const Uuid().v4(),
      name: model.name,
      studentClass: model.studentClass,
      gender: model.gender,
      collage: model.collage,
      phone: model.phone,
      active: model.active,
      createdOn: model.createdOn,
      updatedOn: model.updatedOn,
    );

    final int rowId = await database.insert(
      'students',
      studentModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (rowId > 0) {
      return 'Data murid berhasil disimpan.';
    } else {
      throw Exception('Gagal menyimpan data murid.');
    }
  }

  @override
  Future<List<StudentEntity>> list() async {
    final database = await db.database;
    final List<Map<String, dynamic>> maps = await database.query('students');
    return maps.map((e) => StudentModel.fromMap(e).toEntity()).toList();
  }

  @override
  Future<StudentEntity> get(String id) async {
    final database = await db.database;
    final List<Map<String, dynamic>> maps = await database.query(
      'students',
      where: '_id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw ServerException('Data murid tidak ditemukan.');
    }

    return StudentModel.fromMap(maps.first);
  }

  @override
  Future<String> updateStudents(StudentEntity model) async {
    final database = await db.database;
    final studentModel = StudentModel(
      id: model.id,
      name: model.name,
      studentClass: model.studentClass,
      gender: model.gender,
      collage: model.collage,
      phone: model.phone,
      active: model.active,
      createdOn: model.createdOn,
      updatedOn: model.updatedOn,
    );

    final int count = await database.update(
      'students',
      studentModel.toMap(),
      where: '_id = ?',
      whereArgs: [model.id],
    );

    if (count > 0) {
      return 'Data murid berhasil diperbarui.';
    } else {
      throw Exception('Gagal memperbarui data murid.');
    }
  }

  @override
  Future<String> deleteStudents(String id) async {
    final database = await db.database;

    final int rowId = await database.delete(
      'students',
      where: '_id = ?',
      whereArgs: [id],
    );

    if (rowId > 0) {
      return 'Data murid berhasil dihapus.';
    } else {
      throw BadRequestException('Gagal menghapus data murid.');
    }
  }
}
