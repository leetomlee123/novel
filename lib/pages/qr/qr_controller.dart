import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrController extends GetxController {
final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
    @override
    void onInit() {
    super.onInit();
    }
 void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
        result = scanData;
    });
  }
    @override
    void onReady() {}

    @override
    void onClose() {
       controller?.dispose();
    }

}
