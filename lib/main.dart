import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/services/locationService.dart';
import 'package:watch_me_gps/ui/mainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LocationModel>.value(
      value: LocationService().locationStream,
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'RobotoMono',
        ),
        title: 'Watch Me GPS',
        color: Colors.white,
        home: MainPage(),
      ),
    );
  }
}
