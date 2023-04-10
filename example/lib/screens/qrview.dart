import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner_example/screens/history.dart';
import 'package:qr_code_scanner_example/sql/sqlHelper.dart';
import 'package:qr_code_scanner_example/themes.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var _logr = Logger();
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
      backgroundColor: Color.fromARGB(179, 0, 0, 0),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Expanded(flex: 4, child: _buildQrView(context)),
          Container(
            // flex: 1,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.3,
              child: Container(
                //height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).backgroundColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // if (result != null)
                    //   Text(
                    //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                    // else
                    //   const Text('Scan a code'),
                    Center(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).buttonColor,
                                      shape: StadiumBorder()),
                                  onPressed: () async {
                                    await controller?.toggleFlash();
                                    setState(() {});
                                  },
                                  child: FutureBuilder(
                                    future: controller?.getFlashStatus(),
                                    builder: (context, snapshot) {
                                      return Icon(snapshot.data == true
                                          ? Icons.flash_off
                                          : Icons.flash_on);
                                      // return Text('Flash: ${snapshot.data}');
                                    },
                                  )),
                              "flash".text.make()
                            ],
                          ).pLTRB(10, 7, 7, 7),
                          Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).buttonColor,
                                      shape: StadiumBorder()),
                                  onPressed: () async {
                                    await controller?.flipCamera();
                                    setState(() {});
                                  },
                                  child: FutureBuilder(
                                      future: controller?.getCameraInfo(),
                                      builder: (context, snapshot) {
                                        debugPrint("flipCamera data" +
                                            snapshot.data.toString());
                                        return Icon(snapshot.data.toString() ==
                                                "CameraFacing.front"
                                            ? Icons.flip_camera_android
                                            : Icons.camera_front_sharp);

                                        // if (snapshot.data != null) {
                                        //   return Text(
                                        //       'Camera facing ${describeEnum(snapshot.data!)}');
                                        // } else {
                                        //   return const Text('loading');
                                        // }
                                      })),
                              "camera".text.make()
                            ],
                          ).p(7),
                          Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).buttonColor,
                                      shape: StadiumBorder()),
                                  onPressed: () async {
                                    await controller?.pauseCamera();
                                  },
                                  child: Icon(Icons.pause)),
                              "pause".text.make()
                            ],
                          ).p(7),

                          Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).buttonColor,
                                      shape: StadiumBorder()),
                                  onPressed: () async {
                                    await controller?.resumeCamera();
                                  },
                                  child: Icon(Icons.play_arrow_rounded)),
                              "resume".text.make()
                            ],
                          ).p(7)

                          // if (snapshot.data != null) {
                          //   return Text(
                          //       'Camera facing ${describeEnum(snapshot.data!)}');
                          // } else {
                          //   return const Text('loading');
                          // }
                        ],
                      ),
                    ),

                    TextFormField(
                      key: Key(result != null
                          ? result!.code.toString()
                          : "Scaning..."),
                      readOnly: true,
                      initialValue: result != null
                          ? result!.code.toString()
                          : "Scaning...",
                      enableInteractiveSelection: false,
                      maxLines: 1,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(201, 201, 201, 1)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          tooltip: "Copy",
                          icon: Icon(Icons.copy),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(
                                text: result != null
                                    ? result!.code.toString()
                                    : "Scaning..."));

                            Fluttertoast.showToast(
                                msg: "Copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                        ),
                      ),
                    ).pLTRB(10, 10, 10, 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     Container(
                    //       margin: const EdgeInsets.all(8),
                    //       child: ElevatedButton(
                    //           onPressed: () async {
                    //             await controller?.toggleFlash();
                    //             setState(() {});
                    //           },
                    //           child: FutureBuilder(
                    //             future: controller?.getFlashStatus(),
                    //             builder: (context, snapshot) {
                    //               return Icon(snapshot.data == "true"
                    //                   ? Icons.flash_on
                    //                   : Icons.flash_off);
                    //               // return Text('Flash: ${snapshot.data}');
                    //             },
                    //           )),
                    //     ),
                    //     Container(
                    //       margin: const EdgeInsets.all(8),
                    //       child: ElevatedButton(
                    //           onPressed: () async {
                    //             await controller?.flipCamera();
                    //             setState(() {});
                    //           },
                    //           child: FutureBuilder(
                    //             future: controller?.getCameraInfo(),
                    //             builder: (context, snapshot) {
                    //               if (snapshot.data != null) {
                    //                 return Text(
                    //                     'Camera facing ${describeEnum(snapshot.data!)}');
                    //               } else {
                    //                 return const Text('loading');
                    //               }
                    //             },
                    //           )),
                    //     )
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     Container(
                    //       margin: const EdgeInsets.all(8),
                    //       child: ElevatedButton(
                    //         onPressed: () async {
                    //           await controller?.pauseCamera();
                    //         },
                    //         child: const Text('pause',
                    //             style: TextStyle(fontSize: 20)),
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: const EdgeInsets.all(8),
                    //       child: ElevatedButton(
                    //         onPressed: () async {
                    //           await controller?.resumeCamera();
                    //         },
                    //         child: const Text('resume',
                    //             style: TextStyle(fontSize: 20)),
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ).pLTRB(10, 10, 10, 20)
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 200.0
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

  var lastValue = "";
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _logr.d("result" + result.toString());

        if (result!.code != null && lastValue != result!.code.toString()) {
          // add result to database
          addDataSql(result!.code.toString());
          lastValue = result!.code.toString();
          // vibrate the phone
          Vibrate.vibrate();
          vibratePhone();
        }
      });
    });
  }

  void vibratePhone() {
    // send vibration to phone

    HapticFeedback.mediumImpact();
  }

  void addDataSql(String data) async {
    int returnedID = await SqlHelper.createItem(data);
    debugPrint("returnedID" + returnedID.toString());
    //_logr.d("returnedID" + returnedID.toString());
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
