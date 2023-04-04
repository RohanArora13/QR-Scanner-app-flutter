import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OldView extends StatefulWidget {
  const OldView({Key? key}) : super(key: key);

  @override
  State<OldView> createState() => _OldViewState();
}

class _OldViewState extends State<OldView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (result != null)
          Text(
              'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
        else
          const Text('Scan a code'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return Icon(snapshot.data == "true"
                          ? Icons.flash_on
                          : Icons.flash_off);
                      // return Text('Flash: ${snapshot.data}');
                    },
                  )),
            ),
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
                            'Camera facing ${describeEnum(snapshot.data!)}');
                      } else {
                        return const Text('loading');
                      }
                    },
                  )),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () async {
                  await controller?.pauseCamera();
                },
                child: const Text('pause', style: TextStyle(fontSize: 20)),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () async {
                  await controller?.resumeCamera();
                },
                child: const Text('resume', style: TextStyle(fontSize: 20)),
              ),
            )
          ],
        ),
      ],
    );
  }
}
