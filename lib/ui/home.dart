import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:watch_me_gps/models/locationModel.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final navigationItems = <BottomNavigationBarItem>[
      new BottomNavigationBarItem(
          icon: new Icon(Icons.home, color: Colors.red), title: new Text("")),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.home, color: Colors.red), title: new Text(""))
    ];
    var location = Provider.of<LocationModel>(context);

    String addressText;
    if (location?.address?.postalCode != null) {
      addressText =
          '${location.address.postalCode} ${location.address.locality}, ${location.address.thoroughfare} ${location.address.subThoroughfare}, ${location.address.country}';
    }

    String latitudeAndLongitudeText;
    if (location?.latitude != null) {
      latitudeAndLongitudeText = '${location.latitude},${location.longitude}';
    }

    final String loadingText = '...';

    return new Scaffold(
        appBar: AppBar(
          title: Text('title'),
          backgroundColor: Colors.blueAccent,
        ),
        body: new ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text(
                          '${addressText != null ? addressText : loadingText}'),
                      subtitle: Text('Address'),
                    ),
                    ListTile(
                      leading: Icon(Icons.gps_fixed),
                      title: Text(
                          '${latitudeAndLongitudeText != null ? latitudeAndLongitudeText : loadingText}'),
                      subtitle: Text('Coordinates'),
                    ),
                    ListTile(
                      leading: Icon(Icons.gps_fixed),
                      title: Text(
                          '${location != null ? location.altitude : loadingText}'),
                      subtitle: Text('Altitude'),
                    ),
                    ListTile(
                      leading: Icon(Icons.gps_fixed),
                      title: Text(
                          '${location != null ? location.speed : loadingText}'),
                      subtitle: Text('Speed'),
                    ),
                  ],
                ),
              )
            ]));
  }
}
