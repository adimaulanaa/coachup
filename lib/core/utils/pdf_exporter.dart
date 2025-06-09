import 'dart:io';
import 'dart:typed_data';
import 'package:coachup/core/utils/permission_storage.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/coaching/domain/entities/detail_coaching_entity.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

String? savedFilePath;

Future<Uint8List> generateCoachingPdf(DetailCoachingEntity detail) async {
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
  final tgl = formatTanggalManual(detail.date.toString());
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

            pw.Text("Tanggal: $tgl", style: normalStyle),
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
                            child: pw.Text("Jenis Kelamin",
                                style: tableHeaderStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text("Sekolah", style: tableHeaderStyle),
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
Future<void> savePdfToDownload(
  BuildContext context,
  DetailCoachingEntity detail,
) async {
  final hasPermission = await checkAndRequestStoragePermission(context);
  if (!hasPermission) return;

  final pdfData = await generateCoachingPdf(detail);

  final downloadsDir = await getExternalStorageDirectory();
  if (downloadsDir == null) {
    // ignore: use_build_context_synchronously
    context.showErrorSnackBar('Download directory not found');
    return;
  }

  final fileName = await generateUniqueFileName(
    directoryPath: downloadsDir.path,
    schoolName: detail.picCollage ?? "Laporan",
    date: DateTime.parse(detail.date ?? DateTime.now().toString()),
  );

  final fullPath = "${downloadsDir.path}/$fileName";

  // Simpan manual ke file sebelum dialog
  final file = File(fullPath);
  await file.writeAsBytes(pdfData);

  final params = SaveFileDialogParams(
    sourceFilePath: fullPath,
    fileName: fileName,
    mimeTypesFilter: ['application/pdf'],
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
  // ignore: avoid_print
  print(' saved at: $savedPath');
}

String formatTanggalManual(String tanggal) {
  final date = DateTime.parse(tanggal);

  const hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  const bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final namaHari = hari[date.weekday - 1];
  final namaBulan = bulan[date.month - 1];

  return "$namaHari, ${date.day} $namaBulan ${date.year}";
}

Future<void> savePdfToDownloadPrivate(
  BuildContext context,
  PrivatesEntity detail,
) async {
  final hasPermission = await checkAndRequestStoragePermission(context);
  if (!hasPermission) return;

  final pdfData = await generatePrivatePdf(detail);

  final downloadsDir = await getExternalStorageDirectory();
  if (downloadsDir == null) {
    // ignore: use_build_context_synchronously
    context.showErrorSnackBar('Download directory not found');
    return;
  }

  final fileName = await generateUniqueFileName(
    directoryPath: downloadsDir.path,
    schoolName: detail.name ?? "Laporan",
    date: DateTime.parse(detail.date ?? DateTime.now().toString()),
  );

  final fullPath = "${downloadsDir.path}/$fileName";

  // Simpan manual ke file sebelum dialog
  final file = File(fullPath);
  await file.writeAsBytes(pdfData);

  final params = SaveFileDialogParams(
    sourceFilePath: fullPath,
    fileName: fileName,
    mimeTypesFilter: ['application/pdf'],
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
  // ignore: avoid_print
  print(' saved at: $savedPath');
}

Future<Uint8List> generatePrivatePdf(PrivatesEntity detail) async {
  final pdf = pw.Document();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = prefs.getString('name') ?? '-';
  String title = prefs.getString('title') ?? '-';
  String tlpn = prefs.getString('tlpn') ?? '-';
  String header = prefs.getString('header') ?? '';
  String subHeader = prefs.getString('subHeader') ?? '';
  String coach = prefs.getString('footerCoach') ?? 'Pelatih';
  final format12 = detail.updatedOn != null
      ? DateFormat('hh:mm a').format(detail.updatedOn!)
      : '-';
  List<String> listMurid = detail.student
          ?.split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList() ??
      [];
  bool isMurid = listMurid.isNotEmpty;
  coach = coach == '' ? 'Pelatih' : coach;
  header = header == '' ? 'LAPORAN PRIVATE' : header;
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
  final tgl = formatTanggalManual(detail.date.toString());
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
                  subHeader != ''
                      ? pw.Text(
                          subHeader,
                          style: subtitleHederStyle,
                        )
                      : pw.SizedBox(height: 16),
                  pw.Text(
                    "Tlpn : $tlpn",
                    style: normalStyle,
                  ),
                  pw.SizedBox(height: 16),
                ],
              ),
            ),

            pw.Text("Tanggal: $tgl", style: normalStyle),
            pw.Text("Jam: $format12", style: normalStyle),
            pw.SizedBox(height: 16),

            // Sub-header
            pw.Text("Kegiatan: ${detail.name ?? '-'}", style: titleStyle),
            pw.SizedBox(height: 8),
            pw.Text("Deskripsi: ${detail.description ?? '-'}",
                style: normalStyle),
            pw.SizedBox(height: 16),

            // Anggota
            if (isMurid)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Daftar Peserta:", style: titleStyle),
                  pw.SizedBox(height: 8),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      // kolom nomor dengan lebar tetap 30
                      0: const pw.FixedColumnWidth(30),
                      1: const pw.FlexColumnWidth(1), // kolom nama fleksibel
                    },
                    children: [
                      // Header row
                      pw.TableRow(
                        decoration:
                            const pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text("No.", style: tableHeaderStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text("Nama", style: tableHeaderStyle),
                          ),
                        ],
                      ),
                      // Data rows
                      ...listMurid.asMap().entries.map(
                            (entry) => pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(6),
                                  child: pw.Text(
                                    '${entry.key + 1}', // nomor urut mulai dari 1
                                    style: normalStyle,
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(6),
                                  child:
                                      pw.Text(entry.value, style: normalStyle),
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
                  children: [],
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

Future<String> generateUniqueFileName({
  required String directoryPath,
  required String schoolName,
  required DateTime date,
}) async {
  final formattedDate =
      "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  final baseName = "$schoolName-$formattedDate".replaceAll(' ', '_');
  String fileName = "$baseName.pdf";
  int counter = 1;

  while (await File("$directoryPath/$fileName").exists()) {
    fileName = "$baseName($counter).pdf";
    counter++;
  }

  return fileName;
}
