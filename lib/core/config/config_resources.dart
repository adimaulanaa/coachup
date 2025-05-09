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

  //! Core Network
  static const String student = "Murid Page";
  static const String studentCreated = "Created Murid Page";
  static const String studentEdited = "Edited Murid Page";
  static const String sName = "Nama Murid";
  static const String sClass = "Kelas Murid";
  static const String sGender = "Jenis Kelamin Murid";
  static const String sCollage = "Sekolah Murid";
  static const String sPhone = "Tlpn Murid";
  static const String sActive = "Aktif";
}
