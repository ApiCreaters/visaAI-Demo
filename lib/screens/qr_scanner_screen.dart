import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_rewards/controllers/qr_controller.dart';

/// QR code scanner screen
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final qrController = Get.find<QrController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.qr_code_2,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Position the QR code\ninside the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    // Placeholder for camera scanner
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Obx(() {
                  if (qrController.scannedCode.value.isNotEmpty) {
                    return Column(
                      children: [
                        const Text('Scanned successfully!'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => Get.back(result: qrController.scannedCode.value),
                          child: const Text('Use This Code'),
                        ),
                      ],
                    );
                  }
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.flashlight_on),
                    label: const Text('Toggle Torch'),
                    onPressed: qrController.toggleTorch,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
