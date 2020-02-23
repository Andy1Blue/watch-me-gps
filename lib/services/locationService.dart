import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:watch_me_gps/models/addressModel.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/services/fetchLocation.dart';
import 'package:watch_me_gps/models/sendDataModel.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';

class LocationService {
  LocationModel _currentLocation;
  AddressModel _currentAddress;
  Placemark place;
  String userName;
  Geolocator location = Geolocator();
  StreamController<LocationModel> _streamLocationController =
      StreamController<LocationModel>.broadcast();

  LocationService() {
    location.checkGeolocationPermissionStatus().then((granted) {
      if (granted == GeolocationStatus.granted) {
        location.getPositionStream().listen((locationData) {
          location.isLocationServiceEnabled().then((service) {
            if (locationData != null) {
              getAddressFromLatLng(
                  locationData.latitude, locationData.longitude);

              _streamLocationController.add(LocationModel(
                  latitude: locationData.latitude,
                  longitude: locationData.longitude,
                  altitude: locationData.altitude,
                  speed: locationData.speed,
                  address: _currentAddress,
                  timestamp: locationData.timestamp));

              SharedPreferencesService()
                  .loadData('userName')
                  .then((userNameValue) {
                this.userName = userNameValue;
              });

              var dataToSend = {
                'user': '${userName != null ? userName : 'Flutter'}',
                'location':
                    '${locationData.latitude},${locationData.longitude}',
                'data': '${locationData.timestamp}',
                'other':
                    '${locationData.timestamp}/${locationData.speed}/null}',
              };

              FetchLocation(dataToSend);
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
      var _location = await location.getCurrentPosition();
      getAddressFromLatLng(_location.latitude, _location.longitude);
      await location.isLocationServiceEnabled().then((service) {
        if (_location.latitude != null) {
          _currentLocation = LocationModel(
              latitude: _location.latitude,
              longitude: _location.longitude,
              altitude: _location.altitude,
              speed: _location.speed,
              address: _currentAddress,
              timestamp: _location.timestamp);
        }
      });
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
