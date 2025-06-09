import 'dart:io';

import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkAndRequestStoragePermission(BuildContext context) async {
  if (!Platform.isAndroid && !Platform.isIOS) return true;

  final supported = await _isPermissionSupported();
  if (!supported) return true; // Android 13+ biasanya tak butuh permission

  final granted = await _getStoragePermissionStatus();
  if (granted) return true;

  final requested = await _requestStoragePermission();
  if (!requested) {
    // ignore: use_build_context_synchronously
    _showDeniedSnackbar(context);
  }

  return requested;
}

Future<bool> _isPermissionSupported() async {
  if (Platform.isIOS) return false;

  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  // Android 10 ke bawah, Android 11 & 12 → butuh permission
  return sdkInt < 33;
}

Future<bool> _getStoragePermissionStatus() async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  if (sdkInt >= 30 && sdkInt < 33) {
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  } else if (sdkInt < 30) {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  return true;
}

Future<bool> _requestStoragePermission() async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  if (sdkInt >= 30 && sdkInt < 33) {
    await Permission.manageExternalStorage.request();
    final updated = await Permission.manageExternalStorage.status;
    return updated.isGranted;
  } else if (sdkInt < 30) {
    await Permission.storage.request();
    final updated = await Permission.storage.status;
    return updated.isGranted;
  }

  return true;
}

void _showDeniedSnackbar(BuildContext context) {
  context.showErrorSnackBar(
    'Izin penyimpanan ditolak. Aktifkan di pengaturan.',
    onNavigate: () {
      openAppSettings();
    },
  );
}

/// Minta permission storage sesuai versi Android
Future<bool> requestStoragePermission(BuildContext context) async {
  if (!Platform.isAndroid) return true;

  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  // Helper buat dialog
  Future<bool> showPermissionRationale(String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Permission Diperlukan"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Tolak"),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("Izinkan"),
              ),
            ],
          ),
        ) ??
        false;
  }

  bool granted = false;

  if (sdkInt >= 30 && sdkInt < 33) {
    final status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      granted = true;
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      final userAccept = await showPermissionRationale(
        'Aplikasi perlu izin "Manage External Storage" untuk menyimpan file PDF.',
      );

      if (userAccept) {
        final result = await Permission.manageExternalStorage.request();
        granted = result.isGranted;
      }
    } else if (status.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        'Izin ditolak permanen. Buka pengaturan untuk memberikan izin.',
        onNavigate: openAppSettings,
      );
    }
  } else if (sdkInt < 30) {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      granted = true;
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      final userAccept = await showPermissionRationale(
        'Aplikasi perlu izin "Storage" untuk menyimpan file PDF.',
      );

      if (userAccept) {
        final result = await Permission.storage.request();
        granted = result.isGranted;
      }
    } else if (status.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        'Izin ditolak permanen. Buka pengaturan untuk memberikan izin.',
        onNavigate: openAppSettings,
      );
    }
  } else {
    // Android 13+ (SDK 33 ke atas), biasanya sudah auto granted jika pakai SAF / folder download
    granted = true;
  }

  return granted;
}
