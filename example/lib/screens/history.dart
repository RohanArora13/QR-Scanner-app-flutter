import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_example/sql/sqlHelper.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/popupMenu.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

bool _isLoading = true;
List<Map<String, dynamic>> _dataList = [];

var _logr = Logger();

class _HistoryPageState extends State<HistoryPage> {
  void getData() async {
    _dataList = await SqlHelper.getItems();
    //_dataList = new List.from(_dataList.reversed);
    if (_dataList != null) {
      _isLoading = false;
      debugPrint("DataList = " + _dataList.toString());
      _logr.d("DataList = " + _dataList.toString());
      setState(() {});
    }
  }

  void addData() async {
    int returnedID = await SqlHelper.createItem("test data 123123");
    debugPrint("returnedID" + returnedID.toString());
    // _logr.d("returnedID" + returnedID.toString());
  }

  @override
  void initState() {
    _logr.d("initState");
    //addData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "History".text.xl2.end.make(),
        actions: [
          MyPopupMenu(
            changeState: () {
              getData();
              //setState(() {});
            },
          )
        ],
      ),
      body: Column(
        children: [
          if (_dataList != null && _dataList.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _dataList.length,
                itemBuilder: (context, index) => Stack(
                  alignment: Alignment.center,
                  children: [
                    TextFormField(
                      readOnly: true,
                      initialValue: _dataList[index]['scannedData'].toString(),
                      enableInteractiveSelection: false,
                      maxLines: 1,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(201, 201, 201, 1)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          tooltip: "Copy",
                          icon: Icon(Icons.copy),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(
                                text: _dataList[index]['scannedData']
                                    .toString()));

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
                    Positioned(
                        bottom: 5,
                        left: 30,
                        child: Text(
                          "  ${_dataList[index]['createdAt'].toString()}‎‎  .",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              backgroundColor:
                                  Color.fromARGB(249, 255, 255, 255)),
                        ))
                  ],
                ),
              ),
            )
          ] else ...[
            Expanded(
              child: Center(
                  child: Text("No Scan Found.Scan something than come back")),
            )
          ]
        ],
      ),
    );
  }
}
