import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardEntity> getDash(String day);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final db = DatabaseService();

  @override
  Future<DashboardEntity> getDash(String day) async {
    final database = await db.database;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> maps = await database.query(
      'coaches',
      where: 'date = ?',
      whereArgs: [day],
    );
    final List<Map<String, dynamic>> priv = await database.query(
      'privates',
      where: 'date = ?',
      whereArgs: [day],
    );
    List<CoachEntity> allCoaches =
        maps.map((e) => CoachModel.fromMap(e).toEntity()).toList();
    List<PrivatesEntity> allPrivate =
        priv.map((e) => PrivatesModel.fromMap(e).toEntity()).toList();

    String name = prefs.getString('name') ?? '';
    String title = prefs.getString('title') ?? '';

    DashboardEntity model = DashboardEntity(
      name: name,
      title: title,
      coach: allCoaches.length,
      private: allPrivate.length,
    );

    return model;
  }

// Fungsi bantu untuk membandingkan tanggal
  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
