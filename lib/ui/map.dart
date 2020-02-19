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
  LatLng _location;
  MapController mapController = MapController();
  Widget build(BuildContext context) {
    var location = Provider.of<LocationModel>(context);

    setState(() {
      _location = LatLng(location.latitude, location.longitude);

      if (mapController.ready) {
        mapController.move(_location, 15.0);
      }
    });

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Colors.black),
            child: Column(children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '${_location.latitude}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  )),
              Flexible(
                  child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: _location,
                  zoom: 15.0,
                  // maxZoom: 5.0,
                  // minZoom: 3.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 20.0,
                        height: 20.0,
                        point: _location,
                        builder: (ctx) => new Container(
                          child: new Icon(Icons.arrow_drop_down_circle,
                              color: Colors.red),
                        ),
                      )
                    ],
                  )
                ],
              ))
            ])));
  }
}
