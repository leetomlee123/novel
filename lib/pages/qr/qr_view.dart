import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'qr_controller.dart';

class QrPage extends GetView<QrController> {
    const QrPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
     return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: controller.qrKey,
              onQRViewCreated: controller.onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (controller. result != null)
                  ? Text(
                      'Barcode Type: ')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
    }
}
