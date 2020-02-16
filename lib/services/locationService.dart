import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:watch_me_gps/models/addressModel.dart';
import 'package:watch_me_gps/models/locationModel.dart';

class LocationService {
  LocationModel _currentLocation;
  AddressModel _currentAddress;
  Placemark place;
  Location location = Location();
  StreamController<LocationModel> _streamLocationController =
      StreamController<LocationModel>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted) {
        location.onLocationChanged().listen((locationData) {
          location.serviceEnabled().then((service) {
            if (locationData != null) {
              getAddressFromLatLng(
                  locationData.latitude, locationData.longitude);
              _streamLocationController.add(LocationModel(
                  isServiceEnabled: service,
                  latitude: locationData.latitude,
                  longitude: locationData.longitude,
                  altitude: locationData.altitude,
                  speed: locationData.speed,
                  address: _currentAddress));
            }
          });
        });
      } else {
        print('Chceck the permissions!');
      }
    });
  }

  Stream<LocationModel> get locationStream => _streamLocationController.stream;

  Future<LocationModel> getLocation() async {
    try {
      var _location = await location.getLocation();

      if (_currentLocation.latitude != null) {
        _currentLocation = LocationModel(
            latitude: _location.latitude,
            longitude: _location.longitude,
            altitude: _location.altitude,
            speed: _location.speed);
      }
    } catch (error) {
      print('Can\'t get the location, $error');
    }

    return _currentLocation;
  }

  Future<AddressModel> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> p =
          await Geolocator().placemarkFromCoordinates(latitude, longitude);
      place = p[0];
      print(place);
      _currentAddress = AddressModel(
          locality: place.locality,
          postalCode: place.postalCode,
          country: place.country,
          subThoroughfare: place.subThoroughfare,
          thoroughfare: place.thoroughfare,
          subLocality: place.subLocality,
          subAdministrativeArea: place.subAdministrativeArea,
          name: place.name);
    } catch (error) {
      print('Can\'t get the address, $error');
    }

    return _currentAddress;
  }
}
