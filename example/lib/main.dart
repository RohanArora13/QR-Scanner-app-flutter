import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner_example/screens/history.dart';
import 'package:qr_code_scanner_example/screens/qrview.dart';
import 'package:qr_code_scanner_example/sql/sqlHelper.dart';
import 'package:qr_code_scanner_example/themes.dart';
import 'bottomNav.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'themes.dart';

void main() => runApp(MyHome());

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;

  List<Widget> pageList = [
    const QRViewExample(),
    const HistoryPage(),
    const MyBottomNav(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),

      home: Scaffold(
        //appBar: AppBar(title: const Text('Flutter Demo Home Page')),
        body: SafeArea(child: pageList.elementAt(_selectedIndex)),
        // body: Center(
        //   child: Column(
        //     children: [
        //       ElevatedButton(
        //         onPressed: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //             builder: (context) => const QRViewExample(),
        //           ));
        //         },
        //         child: const Text('qrView'),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //             builder: (context) => const MyBottomNav(),
        //           ));
        //         },
        //         child: const Text('bottom Nav'),
        //       ),
        //     ],
        //   ),
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}