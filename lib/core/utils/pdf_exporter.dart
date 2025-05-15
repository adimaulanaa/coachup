import 'dart:io';
import 'dart:typed_data';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/coaching/domain/entities/detail_coaching_entity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

String? savedFilePath;

/// Minta permission storage sesuai versi Android
Future<bool> requestStoragePermission({BuildContext? context}) async {
  if (!Platform.isAndroid) return true;

  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  bool granted = false;

  if (sdkInt >= 30 && sdkInt < 33) {
    // Android 11 & 12
    final status = await Permission.manageExternalStorage.request();
    granted = status.isGranted;
    if (!granted && context != null) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        'Manage External Storage permission denied',
        onNavigate: () {},
      );
    }
  } else if (sdkInt < 30) {
    // Android 10 ke bawah
    final status = await Permission.storage.request();
    granted = status.isGranted;
    if (!granted && context != null) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        'Storage permission denied',
        onNavigate: () {},
      );
    }
  } else {
    // Android 13+ (SDK 33 ke atas)
    // Untuk export file PDF ke folder Download biasanya tidak perlu permission khusus
    // jadi kita anggap granted langsung.
    granted = true;
  }

  return granted;
}

Future<Uint8List> generateSamplePdf(DetailCoachingEntity detail) async {
  final pdf = pw.Document();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = prefs.getString('name') ?? '-';
  String title = prefs.getString('title') ?? '-';
  String tlpn = prefs.getString('tlpn') ?? '-';
  String header = prefs.getString('header') ?? 'LAPORAN PELATIHAN';
  String subHeader = prefs.getString('subHeader') ?? '';
  String pic = prefs.getString('footerPic') ?? 'Penanggung Jawab';
  String coach = prefs.getString('footerCoach') ?? 'Pelatih';
  // Define styles (setara dengan Flutter styles)
  final titleHeaderStyle = pw.TextStyle(
    fontSize: 24,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.black,
  );
  final subtitleHederStyle = pw.TextStyle(
    fontSize: 15,
    fontWeight: pw.FontWeight.normal,
    color: PdfColors.black,
  );
  final titleStyle = pw.TextStyle(
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.black,
  );
  final normalStyle = pw.TextStyle(
    fontSize: 12,
    fontWeight: pw.FontWeight.normal,
    color: PdfColors.black,
  );
  final tableHeaderStyle = pw.TextStyle(
    fontSize: 10,
    fontWeight: pw.FontWeight.bold,
  );

  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(32),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header di tengah
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(header, style: titleHeaderStyle),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    subHeader,
                    style: subtitleHederStyle,
                  ),
                  pw.Text(
                    "Tlpn : $tlpn",
                    style: normalStyle,
                  ),
                  pw.SizedBox(height: 16),
                ],
              ),
            ),

            pw.Text("Tanggal: ${detail.date ?? '-'}", style: normalStyle),
            pw.Text(
                "Jam: ${detail.timeStart ?? '-'} - ${detail.timeFinish ?? '-'}",
                style: normalStyle),
            pw.SizedBox(height: 16),

            // Sub-header
            pw.Text("Topik: ${detail.topic ?? '-'}", style: titleStyle),
            pw.SizedBox(height: 8),
            pw.Text("Pembelajaran: ${detail.learning ?? '-'}",
                style: normalStyle),
            pw.SizedBox(height: 8),
            pw.Text("Aktivitas: ${detail.activity ?? '-'}", style: normalStyle),
            pw.SizedBox(height: 8),
            pw.Text("Deskripsi: ${detail.description ?? '-'}",
                style: normalStyle),
            pw.SizedBox(height: 16),

            // Anggota
            pw.Text("Peserta:", style: titleStyle),
            pw.SizedBox(height: 8),
            if (detail.members.isNotEmpty)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Daftar Peserta:", style: titleStyle),
                  pw.SizedBox(height: 8),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(3),
                      1: const pw.FlexColumnWidth(2),
                      2: const pw.FlexColumnWidth(2),
                      3: const pw.FlexColumnWidth(3),
                    },
                    children: [
                      // Header Row
                      pw.TableRow(
                        decoration:
                            const pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text("Nama", style: tableHeaderStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text("Kelas", style: tableHeaderStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text("Gender", style: tableHeaderStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text("Kampus", style: tableHeaderStyle),
                          ),
                        ],
                      ),
                      // Data Rows
                      ...detail.members.map(
                        (e) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(6),
                              child: pw.Text(e.name, style: normalStyle),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(6),
                              child:
                                  pw.Text(e.studentClass, style: normalStyle),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(6),
                              child: pw.Text(e.gender, style: normalStyle),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(6),
                              child: pw.Text(e.collage, style: normalStyle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              pw.Text("Tidak ada peserta", style: normalStyle),

            pw.Spacer(),

            // Footer with signatures
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text(pic, style: normalStyle),
                    pw.SizedBox(height: 50),
                    pw.Text(detail.picName ?? '-', style: normalStyle),
                    pw.Text(detail.picCollage ?? '-', style: normalStyle),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(coach, style: normalStyle),
                    pw.SizedBox(height: 50),
                    pw.Text(name, style: normalStyle),
                    pw.Text(title, style: normalStyle),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

/// Simpan PDF ke folder Download dengan dialog simpan
Future<String?> savePdfToDownload(
  BuildContext context,
  DetailCoachingEntity detail,
) async {
  final hasPermission = await requestStoragePermission(context: context);
  if (!hasPermission) return null;

  final pdfData = await generateSamplePdf(detail);

  final params = SaveFileDialogParams(
    data: pdfData,
    fileName: "sample_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf",
    mimeTypesFilter: ['application/pdf'], // ini yang benar
  );

  final savedPath = await FlutterFileDialog.saveFile(params: params);

  if (savedPath != null) {
    // ignore: use_build_context_synchronously
    context.showSuccesSnackBar(
      'File saved at Folder Download',
      onNavigate: () {},
    );
    savedFilePath = savedPath;
  } else {
    // ignore: use_build_context_synchronously
    context.showErrorSnackBar(
      'Save cancelled',
      onNavigate: () {},
    );
  }

  return savedPath;
}
