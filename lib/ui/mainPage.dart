import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_me_gps/router/routerConsts.dart';
import 'package:watch_me_gps/ui/map.dart';
import 'package:watch_me_gps/ui/home.dart';
import 'package:watch_me_gps/ui/setting.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text('Watch Me GPS'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.grey[100],
        body: WillPopScope(
            onWillPop: () async {
              if (_navigatorKey.currentState.canPop()) {
                _navigatorKey.currentState.pop();
                return false;
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
            )),
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
                title: new Text("Map")),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.settings, color: Colors.white),
                title: new Text("Setting"))
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
