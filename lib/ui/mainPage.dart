import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:watch_me_gps/helper.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/router/routerConsts.dart';
import 'package:watch_me_gps/services/locationService.dart';
import 'package:watch_me_gps/ui/map.dart';
import 'package:watch_me_gps/ui/home.dart';
import 'package:watch_me_gps/ui/setting.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Navigation();
  }
}

class Navigation extends State<MainPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(index);

      if (index == 0) {
        _navigatorKey.currentState.pushNamed(HomeViewRoute);
      }

      if (index == 1) {
        _navigatorKey.currentState.pushNamed(MapViewRoute);
      }

      if (index == 2) {
        _navigatorKey.currentState.pushNamed(SettingViewRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Helper().checkPermissions();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Watch Me GPS'),
        backgroundColor: Colors.black,
        centerTitle: true,
        // leading: new Container(
        //   margin: const EdgeInsets.all(15.0),
        //   child: new Icon(
        //     Icons.gps_fixed,
        //     color: Colors.white24,
        //     size: 30.0,
        //   ),
        // ),
      ),
      backgroundColor: Colors.grey[100],
      body: WillPopScope(
        onWillPop: () async {
          if (_navigatorKey.currentState.canPop()) {
            _navigatorKey.currentState.pop();
            return true;
          }
          return true;
        },
        child: Navigator(
          key: _navigatorKey,
          initialRoute: HomeViewRoute,
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
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
            return MaterialPageRoute(
              builder: builder,
              settings: settings,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home, color: Colors.white),
            title: new Text("Home"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.map, color: Colors.white),
            title: new Text("Map"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.settings, color: Colors.white),
            title: new Text("Setting"),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
