import 'package:get/get.dart';
import 'package:wallet_rewards/services/qr_service.dart';

/// QR code GetX controller for scanning and generating QR codes
class QrController extends GetxController {
  final QrService _qrService = QrService();

  final RxString scannedCode = RxString('');
  final RxBool isScanning = RxBool(false);
  final RxBool isTorchOn = RxBool(false);
  final RxString errorMessage = RxString('');

  /// Generate QR code for a card
  String generateQrCode({
    required String cardId,
    required String restaurantId,
    required String userId,
  }) {
    try {
      errorMessage.value = '';
      final qrCode = _qrService.generateQrCode(
        cardId: cardId,
        restaurantId: restaurantId,
        userId: userId,
      );
      return qrCode;
    } catch (e) {
      errorMessage.value = e.toString();
      return '';
    }
  }

  /// Handle scanned QR code
  Future<void> processScannedCode(String code) async {
    try {
      errorMessage.value = '';
      scannedCode.value = code;

      if (!_qrService.isValidQrCode(code)) {
        errorMessage.value = 'Invalid QR code format';
        return;
      }

      final parsedData = _qrService.parseQrCode(code);
      if (parsedData != null) {
        // Successfully parsed QR code
        print('QR Code Data: $parsedData');
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  /// Validate QR code
  bool isValidQrCode(String code) {
    return _qrService.isValidQrCode(code);
  }

  /// Parse QR code data
  Map<String, String>? parseQrCode(String code) {
    return _qrService.parseQrCode(code);
  }

  /// Clear scanned code
  void clearScannedCode() {
    scannedCode.value = '';
    errorMessage.value = '';
  }

  /// Toggle torch
  void toggleTorch() {
    isTorchOn.value = !isTorchOn.value;
  }
}
