import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:coachup/features/services/database_service.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardEntity> getDash(int day);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final db = DatabaseService();

  @override
  Future<DashboardEntity> getDash(int day) async {
    final database = await db.database;
    final List<Map<String, dynamic>> maps = await database.query('coaches');
    List<CoachEntity> allCoaches =
        maps.map((e) => CoachModel.fromMap(e).toEntity()).toList();

    // Filter berdasarkan day
    final today = DateTime.now();
    List<CoachEntity> coaches = allCoaches.where((e) {
      final date = DateTime.tryParse(e.date);
      if (date == null) return false;

      switch (day) {
        case 1:
          return isSameDate(date, today);
        case 2:
          return date.isAfter(today.subtract(const Duration(days: 1))) &&
              date.isBefore(today.add(const Duration(days: 3)));
        case 3:
          return date.isAfter(today.subtract(const Duration(days: 1))) &&
              date.isBefore(today.add(const Duration(days: 7)));
        default:
          return true; // tanpa filter
      }
    }).toList();

    int member = 0;
    for (var e in coaches) {
      if (e.members != '') {
        int total = e.members.split(',').length;
        member += total;
      }
    }

    DashboardEntity model = DashboardEntity(
      coach: coaches.length,
      collage: coaches.length,
      student: member,
      coaches: coaches,
    );

    return model;
  }

// Fungsi bantu untuk membandingkan tanggal
  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
