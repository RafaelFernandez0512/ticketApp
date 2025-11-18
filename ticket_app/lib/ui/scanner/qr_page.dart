import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:ticket_app/data/service/api_service.dart';

class QRPage extends StatefulWidget {
  ApiService apiService = Get.find<ApiService>();
  QRPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrStatePage();
}

class _QrStatePage extends State<QRPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Ticket'),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent)),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              child: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  return Icon(
                    snapshot.data ?? false ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  );
                },
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Scan a code',
                      style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${snapshot.data!.name}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
      _scanSub = controller.scannedDataStream.listen(_onScan); 
  }
    @override
  void dispose() {
    _scanSub?.cancel();
    controller?.dispose();
    super.dispose();
  }
    StreamSubscription<Barcode>? _scanSub;
  Future<void> _onScan(Barcode scanData) async {
    if (_handling) return; // evita reentradas
    _handling = true;

    try {
      // Detén/pausa la cámara y espera a que termine
      await controller?.stopCamera(); // o: await controller?.pauseCamera();

      final id = int.tryParse(scanData.code ?? '') ?? -1;
      final message =
          await widget.apiService.verifyStatusReservation(id);

      if (!mounted) return;

      // Evita abrir múltiples diálogos
      if (Get.isDialogOpen != true) {
        await Get.dialog(
          AlertDialog(
            title: const Text('Alert'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }

      if (!mounted) return;

      setState(() {
        result = scanData;
      });
    } catch (e) {
      // Manejo opcional de errores
      // print(e);
    } finally {
      // Pequeño respiro para que la cámara vuelva estable
      await Future.delayed(const Duration(milliseconds: 300));
      await controller?.resumeCamera();
      _handling = false;
    }
  }
    bool _handling = false;
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
