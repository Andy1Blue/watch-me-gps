import 'package:flutter/material.dart';
import 'package:watch_me_gps/ui/home.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Navigation();
  }
}

class Navigation extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: 0,
      items: [
        new BottomNavigationBarItem(
            icon: new Icon(Icons.home, color: Colors.white),
            title: new Text("Home")),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.map, color: Colors.white),
            title: new Text("Map")),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.settings, color: Colors.white),
            title: new Text("Setting"))
      ],
    );
  }
}
