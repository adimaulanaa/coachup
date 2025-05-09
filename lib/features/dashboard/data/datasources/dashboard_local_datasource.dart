
import 'package:coachup/features/services/database_service.dart';

abstract class DashboardLocalDataSource {
  Future<String> getDash(String model);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final db = DatabaseService();

  @override
  Future<String> getDash(String model) async {
    // final database = await db.database;
    // await database.insert(
    //   'attendance',
    //   model.toMap(),
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );
    return '';
  }
}
