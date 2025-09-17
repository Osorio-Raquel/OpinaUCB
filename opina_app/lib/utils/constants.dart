// lib/utils/constants.dart
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class Constants {
  // pon tu ngrok real:
  static const String ngrokUrl = 'https://febf27f9be67.ngrok-free.app';

  static const String localPc = 'http://localhost:3000';      // PC / Web
  static const String localMobileCable = 'http://127.0.0.1:3000'; // Cel con adb reverse

  /// lista de candidatos según plataforma (primero cable, luego ngrok en mobile)
  static List<String> get candidateUrls {
    if (kIsWeb) return [localPc];
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
        return [localPc];
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return [localMobileCable, ngrokUrl];
      default:
        return [localPc];
    }
  }

  /// Si igual quieres una sola URL “por defecto”
  static String get apiBaseUrl => candidateUrls.first;
}
