import 'package:flutter/material.dart';

class MyBottomNav extends StatefulWidget {
  const MyBottomNav({Key? key}) : super(key: key);

  @override
  State<MyBottomNav> createState() => _MyBottomNavState();
}

class _MyBottomNavState extends State<MyBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(children: <Widget>[
          Column(
            children: [
              FloatingActionButton(
                heroTag: "btn1",
                backgroundColor: Colors.amberAccent,
                onPressed: () {},
                child: const Icon(
                  Icons.train,
                  size: 35,
                  color: Colors.black,
                ),
              ),
              const Text("flash")
            ],
          ),
          FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: Colors.amberAccent,
            onPressed: () {},
            child: const Icon(
              Icons.train,
              size: 35,
              color: Colors.black,
            ),
          ),
        ]),
      ),
    );
  }
}
