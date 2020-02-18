import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watch_me_gps/models/locationModel.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Map> {
  GoogleMapController mapController;
  List<Marker> markers = <Marker>[];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget build(BuildContext context) {
    var location = Provider.of<LocationModel>(context);

    final LatLng _location = LatLng(location.latitude, location.longitude);

    setState(() {
      for (int i = 0; i < 1; i++) {
        markers.add(
          Marker(
            markerId: MarkerId(location.address.locality),
            position: _location,
            infoWindow: InfoWindow(
                title: location.address.locality,
                snippet: location.address.locality),
            onTap: () {},
          ),
        );
      }
    });

    return Scaffold(
        body: GoogleMap(
      onMapCreated: _onMapCreated,
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        tilt: 75.0,
        target: _location,
        zoom: 12.0,
      ),
      markers: Set<Marker>.of(markers),
    ));
  }
}
