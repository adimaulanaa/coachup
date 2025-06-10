import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class PrivatesLocalDataSource {
  Future<List<PrivatesModel>> list(String str, String fns);
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
      // Ambil data di antara str dan fns
      maps = await database.query(
        'privates',
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
        'privates',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [startStr, endStr],
      );
    }
    final result = maps.map((m) => PrivatesModel.fromMap(m)).toList();
    return result;
  }

  @override
  Future<PrivatesModel> get(String id) async {
    final database = await db.database;
    List<Map<String, dynamic>> maps;
    maps = await database.query(
      'privates',
      where: '_id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      // Konversi map pertama ke model
      return PrivatesModel.fromMap(maps.first);
    } else {
      return PrivatesModel(); // tidak ditemukan
    }
  }

  @override
  Future<String> create(PrivatesEntity model) async {
    final database = await db.database;

    // Generate UUID jika id belum ada
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
      return 'Private berhasil disimpan';
    } else {
      throw Exception('Gagal menyimpan Private');
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
      return 'Private berhasil dihapus';
    } else {
      throw BadRequestException('Gagal menghapus Private');
    }
  }

  @override
  Future<String> update(PrivatesEntity model) async {
    final database = await db.database;

    // Konversi entity ke model
    final updateModel = PrivatesModel(
      id: model.id, // pastikan ini wajib ada
      name: model.name,
      description: model.description,
      date: model.date,
      student: model.student,
      studentId: model.studentId,
      createdOn: model.createdOn,
      updatedOn: model.updatedOn, // update waktu terakhir
    );

    final int result = await database.update(
      'privates',
      updateModel.toMap(),
      where: '_id = ?',
      whereArgs: [model.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (result > 0) {
      return 'Private berhasil diupdate';
    } else {
      throw Exception('Gagal mengupdate Private');
    }
  }
}
