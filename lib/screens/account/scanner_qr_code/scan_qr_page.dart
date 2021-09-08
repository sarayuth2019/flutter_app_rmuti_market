import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/account/scanner_qr_code/payment_form_QRcode.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerQRCode extends StatefulWidget {
  ScannerQRCode(this.token);

  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ScannerQRCode(token);
  }
}

class _ScannerQRCode extends State {
  _ScannerQRCode(this.token);

  final token;
  QRViewController? controller;
  final qrKey = GlobalKey();

  Barcode? _barcode;
  int? paymentId;

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    } else {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderRadius: 8,
            ),
          ),
          Positioned(
              bottom: 10,
              child: Container(
                  child: _barcode == null
                      ? Container()
                      : Column(
                          children: [
                           /* ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.teal),
                                onPressed: () {
                                  controller?.stopCamera();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentFormQRCode(
                                                  token, paymentId!)));
                                },
                                child: Text(
                                    'ตรวจสอบ Payment Id ${paymentId.toString()}')),

                            */
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.teal),
                                onPressed: () {
                                  controller?.resumeCamera();
                                },
                                child: Text('Scan New QR Code'))
                          ],
                        )))
        ],
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    if (_barcode == null) {
      this.controller = controller;
      controller.scannedDataStream.listen((barCodeScan) {
        return setState(() {
          this._barcode = barCodeScan;
          controller.pauseCamera();
          paymentId = int.parse(_barcode!.code);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentFormQRCode(token, paymentId!)));
        });
      });
    } else {
      dispose();
    }
  }
}
