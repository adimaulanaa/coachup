import 'package:coachup/features/profile/domain/entities/profile_entity.dart';
import 'package:coachup/features/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileEntity> getProf();
  Future<String> updateProfile(ProfileEntity entity);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final db = DatabaseService();

  @override
  Future<ProfileEntity> getProf() async {
    // final database = await db.database;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? '';
    String title = prefs.getString('title') ?? '';
    String tlpn = prefs.getString('tlpn') ?? '';
    String header = prefs.getString('header') ?? '';
    String subHeader = prefs.getString('subHeader') ?? '';
    ProfileEntity model = ProfileEntity(
      name: name,
      title: title,
      tlpn: tlpn,
      header: header,
      subHeader: subHeader,
    );
    return model;
  }

  @override
  Future<String> updateProfile(ProfileEntity entity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', entity.name ?? '');
    await prefs.setString('title', entity.title ?? '');
    await prefs.setString('tlpn', entity.tlpn ?? '');
    await prefs.setString('header', entity.header ?? '');
    await prefs.setString('subHeader', entity.subHeader ?? '');
    return 'Berhasil ubah profile';
  }
}
