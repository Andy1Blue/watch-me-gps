import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_me_gps/router/routerConsts.dart';

import 'package:watch_me_gps/ui/home.dart';
import 'package:watch_me_gps/ui/map.dart';
import 'package:watch_me_gps/ui/setting.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => Home());
    case MapViewRoute:
      return MaterialPageRoute(builder: (context) => Map());
         case SettingViewRoute:
      return MaterialPageRoute(builder: (context) => Setting());
    default:
      return MaterialPageRoute(builder: (context) => Home());
  }
}
