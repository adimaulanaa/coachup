import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class JsonFileManager {
  static Future<void> saveJsonFile() async {
    try {
      // 1. Minta izin penyimpanan
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Izin penyimpanan ditolak");
        return;
      }

      // 2. Buat data JSON
      Map<String, dynamic> jsonData = {
        "nama": "John Doe",
        "umur": 25,
        "hobi": ["Membaca", "Menulis", "Bersepeda"]
      };

      // 3. Konversi ke format JSON
      String jsonString = jsonEncode(jsonData);

      // 4. Tentukan lokasi penyimpanan
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download"); // Folder Download di Android
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory(); // Folder dokumen di iOS
      }

      if (directory == null) {
        print("Gagal mendapatkan direktori penyimpanan");
        return;
      }

      String filePath = "${directory.path}/data.json";

      // 5. Simpan file JSON
      File file = File(filePath);
      await file.writeAsString(jsonString);

      print("File JSON berhasil disimpan di: $filePath");
    } catch (e) {
      print("Error menyimpan file JSON: $e");
    }
  }
}
