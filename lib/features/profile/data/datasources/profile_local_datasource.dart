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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final model = ProfileEntity(
      name: prefs.getString('name') ?? '',
      title: prefs.getString('title') ?? '',
      tlpn: prefs.getString('tlpn') ?? '',
      header: prefs.getString('header') ?? '',
      subHeader: prefs.getString('subHeader') ?? '',
      footerPic: prefs.getString('footerPic') ?? '',
      footerCoach: prefs.getString('footerCoach') ?? '',
    );

    return model;
  }

  @override
  Future<String> updateProfile(ProfileEntity entity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', entity.name ?? '');
    await prefs.setString('title', entity.title ?? '');
    await prefs.setString('tlpn', entity.tlpn ?? '');
    await prefs.setString('header', entity.header ?? '');
    await prefs.setString('subHeader', entity.subHeader ?? '');
    await prefs.setString('footerPic', entity.footerPic ?? '');
    await prefs.setString('footerCoach', entity.footerCoach ?? '');

    return 'Data profil berhasil diperbarui.';
  }
}
