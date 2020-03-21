import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:sms/sms.dart';
import 'package:watch_me_gps/helper.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/services/sms.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Map> {
  void initState() {
    super.initState();
    setData();
  }

  Helper helper = new Helper();
  bool isTapped = false;
  double userZoom = 18.0;
  double maxZoom = 19.0;
  double minZoom = 3.0;
  LatLng _location = LatLng(1, 1);
  MapController mapController = MapController();
  bool isLoading = false;

  setData() {
    SharedPreferencesService().loadDoubleData('userZoom').then((userZoomSP) {
      setState(() {
        userZoom = userZoomSP;
      });
    });
  }

  Widget build(BuildContext context) {
    var location = Provider.of<LocationModel>(context);
    List<String> phoneNumber = [];
    final loader = helper.loader('Wait for sms send!');

    String addressText = helper.setShortAdressText(location);

    String googleLocationLinkText = helper.setGoogleLocationLinkText(location);

    String speedText = helper.setSpeedText(location);

    String messageToSend =
        '$googleLocationLinkText';

    void _zoomUp() {
      if (maxZoom > userZoom) {
        setState(() {
          userZoom += 1.0;
          SharedPreferencesService().saveDoubleData('userZoom', userZoom);
        });
      }
    }

    void _zoomDown() {
      if (minZoom < userZoom) {
        setState(() {
          userZoom -= 1.0;
          SharedPreferencesService().saveDoubleData('userZoom', userZoom);
        });
      }
    }

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
                          text: "Message was sent",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " to ${phoneNumber[0]}",
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
                          text: " to $messageToSend",
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
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
                    new Timer(const Duration(milliseconds: 3000), () {
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
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

    FlutterMap flutterMap = FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onTap: (LatLng latLng) {
          isTapped = true;
        },
        center: _location,
        zoom: userZoom,
        maxZoom: maxZoom,
        minZoom: minZoom,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [
            new Marker(
              width: 20.0,
              height: 20.0,
              point: _location,
              builder: (ctx) => new Container(
                child:
                    new Icon(Icons.arrow_drop_down_circle, color: Colors.red),
              ),
            )
          ],
        )
      ],
    );

    setState(() {
      _location = LatLng(location.latitude, location.longitude);

      if (mapController.ready) {
        if (isTapped == false) {
          mapController.move(_location, userZoom);
        }
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Stack(
          children: <Widget>[
            Container(child: flutterMap),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '${addressText != null ? addressText : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    backgroundColor: Colors.black87,
                  ),
                ),
              ),
            ),
            !isTapped
                ? Container(
                    padding: const EdgeInsets.only(top: 315.0, right: 5.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ButtonTheme(
                        minWidth: 40.0,
                        height: 40.0,
                        child: new RaisedButton(
                          color: Colors.white,
                          child: new Text(
                            "+",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          onPressed: () {
                            _zoomUp();
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            !isTapped
                ? Container(
                    padding: const EdgeInsets.only(top: 270.0, right: 5.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ButtonTheme(
                        minWidth: 40.0,
                        height: 40.0,
                        child: new RaisedButton(
                          color: Colors.white,
                          child: new Text(
                            "-",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          onPressed: () {
                            _zoomDown();
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            isLoading == true ? loader : Container(),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  child: Icon(Icons.sms),
                  backgroundColor: Colors.black87,
                  onPressed: () async {
                    _showSmsDialog();
                  },
                ),
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
            ),
            isTapped
                ? Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                          child: Icon(Icons.gps_off),
                          backgroundColor: Colors.black87,
                          onPressed: () {
                            setState(() {
                              isTapped = false;
                            });
                          }),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                          child: Icon(Icons.gps_fixed),
                          backgroundColor: Colors.black87,
                          onPressed: () {
                            setState(() {
                              isTapped = true;
                            });
                          }),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
