import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/services/sendSms.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Map> {
  bool isTapped = false;
  double userZoom = 18.0;
  double maxZoom = 19.0;
  double minZoom = 3.0;
  LatLng _location = LatLng(1, 1);
  MapController mapController = MapController();

  Widget build(BuildContext context) {
    var location = Provider.of<LocationModel>(context);
    List<String> phoneNumber = [];
    String addressText;
    if (location?.address?.locality != null) {
      addressText = '';
      if (location.address.locality != '') {
        addressText += location.address.locality + ' ';
      }
      if (location.address.thoroughfare != '') {
        addressText += location.address.thoroughfare + ' ';
      }
      if (location.address.subThoroughfare != '') {
        addressText += location.address.subThoroughfare + ' ';
      }
    }
    String googleLocationLinkText;
    if (location != null) {
      googleLocationLinkText =
          'http://www.google.com/maps/place/${location.latitude},${location.longitude}';
    }

    void _zoomUp() {
      setState(() {
        if (maxZoom > userZoom) {
          userZoom += 1;
        }
      });
    }

    void _zoomDown() {
      setState(() {
        if (minZoom < userZoom) {
          userZoom -= 1.0;
        }
      });
    }

    void _showSmsDialog() {
      SharedPreferencesService()
          .loadData('phoneNumber')
          .then((phoneNumberValue) {
        setState(() {
          phoneNumber.add(phoneNumberValue);
        });
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
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      child: Icon(Icons.sms),
                      backgroundColor: Colors.black87,
                      onPressed: () {
                        _showSmsDialog();
                      })),
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
