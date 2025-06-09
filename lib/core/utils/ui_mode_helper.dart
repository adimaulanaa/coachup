import 'package:flutter/services.dart';

class UiModeHelper {
  /// Aktifkan immersive mode (status bar dan nav bar disembunyikan)
  static void enableImmersive() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  /// Aktifkan mode standar dengan status bar & nav bar muncul
  static void enableDefault() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Aktifkan mode manual jika kamu ingin kontrol penuh
  static void enableFullyVisible() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Sembunyikan status bar saja, nav bar tetap muncul
  static void hideStatusBarOnly() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  /// Sembunyikan nav bar saja, status bar tetap muncul
  static void hideNavBarOnly() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
  }
}
