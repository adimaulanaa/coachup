class StringResources {
  StringResources._();

  //! Core
  // http
  static const String baseUrl = 'https://example.co.id';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  // time to verification OTP
  static const int remainingTime = 180; // for minutes
  static const int timeOutServer = 120; // for minutes

  //! Core Network
  static const String networkFailureMessage = "CoachUp";

  //
  static const String nameApp = "CoachUp";
  static const String titleApp = "CoachUp";
  static const String male = "Laki-laki";
  static const String female = "Perempuan";

  //! Student
  static const String student = "Murid Page";
  static const String studentCreated = "Created Murid Page";
  static const String studentEdited = "Edited Murid Page";
  static const String sName = "Nama Murid";
  static const String sClass = "Kelas Murid";
  static const String sGender = "Jenis Kelamin Murid";
  static const String sCollage = "Sekolah Murid";
  static const String sPhone = "Tlpn Murid";
  static const String sActive = "Aktif";

  //! Coaching
  static const String coach = "Coaches Page";
  static const String coachCreated = "Created Coaches Page";
  static const String coachEdited = "Edited Coaches Page";
  static const String cName = "Nama Pelatihan";
  static const String cTopic = "Topic Pelatihan";
  static const String cMateri = "Materi Pelatihan";
  static const String cDate = "Tanggal";
  static const String cStartTime = "Waktu Mulai";
  static const String cFinishTime = "Waktu Selesai";
  static const String cActivity = "Aktifitas Pelatihan";
  static const String cDesc = "Deskripsi Pelatihan";
  static const String cPicName = "Nama Penanggung Jawab Sekolah";
  static const String cPicCollage = "Nama Sekolah Pelatihan";

  //! Profile
  static const String profile = "Profile Page";
  static const String pName = "Nama";
  static const String pTitle = "Title";
  static const String pTlpn = "Tlpn";
  static const String pHeader = "Title";
  static const String pSubHeader = "Subtitle";
  static const String pFPic = "Text PIC";
  static const String pFCoach = "Text Pelatih";

  //! Coaching
  static const String privates = "Private Page";
  static const String prEdited = "Edited Private Page";
  static const String prCreated = "Created Private Page";
  static const String prName = "Nama Kegiatan";
  static const String prDesc = "Deskripsi Pelatihan";
  static const String prStudent = "Nama Murid";

}
