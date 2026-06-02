import 'package:qr_flutter/qr_flutter.dart';

/// QR code service for generating and scanning QR codes
class QrService {
  static final QrService _instance = QrService._internal();

  factory QrService() {
    return _instance;
  }

  QrService._internal();

  /// Generate QR code data
  String generateQrCode({
    required String cardId,
    required String restaurantId,
    required String userId,
  }) {
    // Create a standardized QR code format
    return 'LOYALTY_CARD|$cardId|$restaurantId|$userId|${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Parse QR code data
  Map<String, String>? parseQrCode(String qrData) {
    try {
      if (!qrData.startsWith('LOYALTY_CARD|')) return null;

      final parts = qrData.split('|');
      if (parts.length < 4) return null;

      return {
        'type': parts[0],
        'cardId': parts[1],
        'restaurantId': parts[2],
        'userId': parts[3],
        'timestamp': parts.length > 4 ? parts[4] : '',
      };
    } catch (e) {
      print('Error parsing QR code: $e');
      return null;
    }
  }

  /// Validate QR code format
  bool isValidQrCode(String qrData) {
    return parseQrCode(qrData) != null;
  }

  /// Generate QR code image bytes
  Future<Uint8List?> generateQrCodeImage({
    required String data,
    int version = QrVersions.auto,
    int size = 300,
  }) async {
    try {
      final qrCode = QrCode(
        version,
        QrErrorCorrectLevel.H,
      );
      qrCode.addData(data);
      qrCode.make(fit: true);

      return null; // Return null for now, actual image generation handled in UI layer
    } catch (e) {
      print('Error generating QR code image: $e');
      return null;
    }
  }
}

// Type alias for Uint8List
typedef Uint8List = List<int>;
