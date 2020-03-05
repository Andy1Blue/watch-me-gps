import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:watch_me_gps/helper.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/services/sendSms.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    Helper helper = new Helper();
    var location = Provider.of<LocationModel>(context);

    final loader = SizedBox(
        height: 40.0,
        width: 40.0,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blue), strokeWidth: 5.0));

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

    String addressText = helper.setAdressText(location);

    String latitudeAndLongitudeText;
    if (location?.latitude != null) {
      latitudeAndLongitudeText = '${location.latitude}, ${location.longitude}';
    }

    String altitudeText;
    if (location?.altitude != null) {
      altitudeText = helper.round(location.altitude).toString() + ' m';
    }

    String speedText;
    if (location?.speed != null) {
      speedText = helper.msToKmh(location.speed).toString() + ' km/h';
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

    String messageToSend =
        '$addressText | $speedText | $googleLocationLinkText';

    void _showSmsDialog() {
      SharedPreferencesService()
          .loadStringData('phoneNumber')
          .then((phoneNumberValue) {
        phoneNumber.add(phoneNumberValue);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Do you really want send your position by SMS?"),
            content: new Text(
                "Recipient: ${phoneNumber[0]}\nMessage:\n$messageToSend"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Send!"),
                onPressed: () {
                  SendSms('$messageToSend', phoneNumber);
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

    var cardLocalisationData = [
      {
        'title': '${timestampText ?? '-'}',
        'description': 'Last update',
        'icon': Icons.calendar_today
      },
      {
        'title': '${addressText ?? '-'}',
        'description': 'Address',
        'icon': Icons.home
      },
      {
        'title': '${latitudeAndLongitudeText ?? '-'}',
        'description': 'Coordinates',
        'icon': Icons.gps_fixed
      },
      {
        'title': '${altitudeText ?? '-'}',
        'description': 'Altitude',
        'icon': Icons.arrow_upward
      },
      {
        'title': '${speedText ?? '-'}',
        'description': 'Spped',
        'icon': Icons.arrow_forward_ios
      },
    ];

    return new Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Stack(
        children: [
          new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: cardLocalisationData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 3.0),
                      child: Card(
                        color: Color.fromRGBO(64, 75, 96, 1.0),
                        elevation: 2,
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                              border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.white24),
                              ),
                            ),
                            child: Icon(cardLocalisationData[index]['icon'],
                                color: Colors.white),
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: '${cardLocalisationData[index]['title']}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              text:
                                  '${cardLocalisationData[index]['description']}',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          onTap: () => {
                            _showAlert(
                                context,
                                '${cardLocalisationData[index]['description']}',
                                cardLocalisationData[index]['title'])
                          },
                        ),
                      ),
                    );
                  },
                ),
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
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, bottom: 70.0, right: 10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  child: Icon(Icons.share),
                  backgroundColor: Colors.black87,
                  onPressed: () {
                    Share.share('$messageToSend');
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
}
