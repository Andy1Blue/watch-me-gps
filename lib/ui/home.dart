import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:sms/sms.dart';
import 'package:watch_me_gps/helper.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/services/sms.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  void initState() {
    super.initState();
  }

  bool isLoading = false;

  Widget build(BuildContext context) {
    Helper helper = new Helper();
    var location = Provider.of<LocationModel>(context);

    final loader = helper.loader('Wait for sms send!');

    String longAddressText = helper.setLongAdressText(location);

    String latitudeAndLongitudeText =
        helper.setLatitudeAndLongitudeText(location);

    String altitudeText = helper.setAltitudeText(location);

    String speedText = helper.setSpeedText(location);

    DateTime timestampText = helper.setTimestampText(location);

    final String loadingText = '-';

    List<String> phoneNumber = [];
    String googleLocationLinkText;
    if (location != null) {
      googleLocationLinkText =
          'http://www.google.com/maps/place/${location.latitude},${location.longitude}';
    }

    String messageToSend = '$googleLocationLinkText';
    String messageToShare =
        'Actual address: $longAddressText\n---\nActual speed: $speedText\n---\nLocalisation link: $googleLocationLinkText';

    void _showConfirmationSmsDialog(sendSms) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: new Text("Confirmation of sending",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            content: RichText(
              text: sendSms
                  ? TextSpan(
                      children: [
                        TextSpan(
                          text: "Message was sent:",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "to ${phoneNumber[0]}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : TextSpan(
                      children: [
                        TextSpan(
                          text: "Message has not been sent",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "to $messageToSend",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: "\n\nTry again!",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
            ),
            actions: <Widget>[
              new FlatButton(
                color: Colors.greenAccent,
                child: new Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: new Text("Do you really want send your position by SMS?",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Recipient:",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\n${phoneNumber[0]}",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: "\n\nMessage:",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\n$messageToSend",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                color: Colors.greenAccent,
                child: new Text(
                  "Send!",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  await Sms().send('$messageToSend', phoneNumber).then((value) {
                    new Timer(const Duration(milliseconds: 1000), () {
                      bool isSend = value.state == SmsMessageState.Sent;
                      isLoading = false;
                      _showConfirmationSmsDialog(isSend);
                      setState(() {
                        isLoading = false;
                      });
                    });
                  });
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                color: Colors.redAccent,
                child: new Text(
                  "Don't send!",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
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
        'title': '${timestampText ?? loadingText}',
        'description': 'Last update',
        'icon': Icons.calendar_today
      },
      {
        'title': '${longAddressText ?? loadingText}',
        'description': 'Address',
        'icon': Icons.home
      },
      {
        'title': '${latitudeAndLongitudeText ?? loadingText}',
        'description': 'Coordinates',
        'icon': Icons.gps_fixed
      },
      {
        'title': '${altitudeText ?? loadingText}',
        'description': 'Altitude',
        'icon': Icons.arrow_upward
      },
      {
        'title': '${speedText ?? loadingText}',
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
          isLoading == true ? loader : Container(),
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
                    Share.share('$messageToShare');
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
