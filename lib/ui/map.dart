import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:watch_me_gps/models/locationModel.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Map> {
  bool isTapped = false;
  LatLng _location;
  MapController mapController = MapController();

  Widget build(BuildContext context) {
    var location = Provider.of<LocationModel>(context);

    void _showSmsDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("SMS"),
            content: new Text("SMS has been send to..."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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

    FlutterMap flutterMap = FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onTap: (LatLng latLng) {
          isTapped = true;
        },
        center: _location,
        zoom: 18.0,
        // maxZoom: 5.0,
        // minZoom: 3.0,
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
          mapController.move(_location, 18.0);
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
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
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
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          child: Icon(Icons.gps_fixed),
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
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          child: Icon(Icons.gps_off),
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
