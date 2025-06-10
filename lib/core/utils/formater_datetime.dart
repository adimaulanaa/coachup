String formatDateManual(String tanggal) {
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