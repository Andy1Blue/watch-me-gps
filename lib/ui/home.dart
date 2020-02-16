import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

    final noGpsAlert = AlertDialog(
      title: Text("No GPS!"),
      content: Text("Check your GPS settings."),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: () {},
        ),
      ],
    );

    var location = Provider.of<LocationModel>(context);

    String addressText;
    if (location?.address?.postalCode != null) {
      addressText = '';
      if (location.address.postalCode != '') {
        addressText += location.address.postalCode + ' ';
      }
      if (location.address.locality != '') {
        addressText += location.address.locality + ' ';
      }
      if (location.address.thoroughfare != '') {
        addressText += location.address.thoroughfare + ' ';
      }
      if (location.address.subThoroughfare != '') {
        addressText += location.address.subThoroughfare + ' ';
      }
      if (location.address.country != '') {
        addressText += location.address.country + ' ';
      }
    }

    String latitudeAndLongitudeText;
    if (location?.latitude != null) {
      latitudeAndLongitudeText = '${location.latitude}, ${location.longitude}';
    }

    String altitudeText;
    if (location?.altitude != null) {
      altitudeText = round(location.altitude).toString() + ' m';
    }

    String speedText;
    if (location?.speed != null) {
      speedText = msToKmh(location.speed).toString() + ' km/h';
    }

    DateTime timestampText;
    if (location?.timestamp != null) {
      timestampText = location.timestamp.toLocal();
    }

    final String loadingText = '-';

    // if (location?.latitude == null) {
    // LocationService().getLocation();
    // }

    return new Scaffold(
        appBar: AppBar(
          title: Text('Watch Me GPS'),
          backgroundColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.blueAccent,
        body: new ListView(padding: const EdgeInsets.all(10.0), children: <
            Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(
                      '${timestampText != null ? timestampText : loadingText}'),
                  subtitle: Text('Last update'),
                ),
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
                  leading: Icon(Icons.arrow_upward),
                  title: Text(
                      '${altitudeText != null ? altitudeText : loadingText}'),
                  subtitle: Text('Altitude'),
                ),
                ListTile(
                  leading: Icon(Icons.arrow_forward_ios),
                  title: Text('${speedText != null ? speedText : loadingText}'),
                  subtitle: Text('Speed'),
                ),
              ],
            ),
          ),
        ]));
  }

  double round(number) {
    return num.parse(number.toStringAsFixed(1));
  }

  double msToKmh(double ms) {
    return round(ms * 3.6);
  }
}
