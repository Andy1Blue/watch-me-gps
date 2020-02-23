import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/services/sendSms.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  Widget build(BuildContext context) {
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

    List<String> phoneNumber = [];
    String googleLocationLinkText;
    if (location != null) {
      googleLocationLinkText =
          'http://www.google.com/maps/place/${location.latitude},${location.longitude}';
    }

    void _showSmsDialog() {
      SharedPreferencesService()
          .loadData('phoneNumber')
          .then((phoneNumberValue) {
        phoneNumber.add(phoneNumberValue);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Do you really want send your position by SMS?"),
            content: new Text(
                "Recipient: ${phoneNumber[0]}\nMessage:\n$googleLocationLinkText\n${addressText != null ? addressText : ''}"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Send!"),
                onPressed: () {
                  SendSms('$googleLocationLinkText', phoneNumber);
                  if (addressText != null) {
                    SendSms('$addressText', phoneNumber);
                  }
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Dont send!"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return new Scaffold(
      body: Stack(
        children: [
          new ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                      child: ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(
                        '${timestampText != null ? timestampText : loadingText}'),
                    subtitle: Text('Last update'),
                    onTap: () => {
                      _showAlert(
                          context, 'Last update', timestampText.toString())
                    },
                  )),
                  Card(
                      child: ListTile(
                    leading: Icon(Icons.home),
                    title: Text(
                        '${addressText != null ? addressText : loadingText}'),
                    subtitle: Text('Address'),
                    onTap: () => {_showAlert(context, 'Address', addressText)},
                  )),
                  Card(
                      child: ListTile(
                    leading: Icon(Icons.gps_fixed),
                    title: Text(
                        '${latitudeAndLongitudeText != null ? latitudeAndLongitudeText : loadingText}'),
                    subtitle: Text('Coordinates'),
                    onTap: () => {
                      _showAlert(
                          context, 'Coordinates', latitudeAndLongitudeText)
                    },
                  )),
                  Card(
                      child: ListTile(
                    leading: Icon(Icons.arrow_upward),
                    title: Text(
                        '${altitudeText != null ? altitudeText : loadingText}'),
                    subtitle: Text('Altitude'),
                    onTap: () =>
                        {_showAlert(context, 'Altitude', altitudeText)},
                  )),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.arrow_forward_ios),
                      title: Text(
                          '${speedText != null ? speedText : loadingText}'),
                      subtitle: Text('Speed'),
                      onTap: () => {_showAlert(context, 'Speed', speedText)},
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  child: Icon(Icons.sms),
                  backgroundColor: Colors.black87,
                  onPressed: () {
                    _showSmsDialog();
                  }),
            ),
          )
        ],
      ),
    );
  }

  void _showAlert(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
            ));
  }

  double round(number) {
    return num.parse(number.toStringAsFixed(1));
  }

  double msToKmh(double ms) {
    return round(ms * 3.6);
  }
}
