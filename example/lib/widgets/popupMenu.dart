import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_example/sql/sqlHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyPopupMenu extends StatelessWidget {
  const MyPopupMenu({Key? key, required this.changeState}) : super(key: key);

  final VoidCallback changeState;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        // add icon, by default "3 dot" icon
        // icon: Icon(Icons.book)
        itemBuilder: (context) {
      return [
        const PopupMenuItem<int>(
          value: 0,
          child: Text("Clear History"),
        ),
      ];
    }, onSelected: (value) async {
      if (value == 0) {
        await SqlHelper.clearTable();
        changeState();

        Fluttertoast.showToast(
            msg: "History Cleared",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
