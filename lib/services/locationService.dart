import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:watch_me_gps/helper.dart';
import 'package:watch_me_gps/models/addressModel.dart';
import 'package:watch_me_gps/models/locationModel.dart';
import 'package:watch_me_gps/services/fetchLocation.dart';
import 'package:watch_me_gps/models/sendDataModel.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';

class LocationService {
  Helper helper;
  AddressModel _currentAddress;
  Placemark place;
  String userName;
  Geolocator location = Geolocator();
  var locationOptions = LocationOptions(
    accuracy: LocationAccuracy.best,
    timeInterval: 3000,
  );
  StreamController<LocationModel> _streamLocationController =
      StreamController<LocationModel>.broadcast();

  LocationService() {
    location.checkGeolocationPermissionStatus().then((granted) {
      if (granted == GeolocationStatus.granted) {
        location.getPositionStream(locationOptions).listen((locationData) {
          location.isLocationServiceEnabled().then((service) async {
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
                  .loadStringData('userName')
                  .then((userNameValue) {
                this.userName = userNameValue;
              });

              String addressForSend;
              if (_currentAddress?.postalCode != null) {
                addressForSend = '';
                if (_currentAddress.locality != '') {
                  addressForSend += _currentAddress.locality + ' ';
                }
                if (_currentAddress.thoroughfare != '') {
                  addressForSend += _currentAddress.thoroughfare + ' ';
                }
                if (_currentAddress.subThoroughfare != '') {
                  addressForSend += _currentAddress.subThoroughfare + ' ';
                }
              }

              String speedForSend =
                  (locationData.speed * 3.6).toStringAsFixed(1).toString() +
                      ' km/h';

              var dataToSend = SendDataModel(
                  user: '${userName != null ? userName : 'Flutter'}',
                  location:
                      '${locationData.latitude},${locationData.longitude}',
                  data: '${locationData.timestamp}',
                  other:
                      "${locationData.timestamp}/${speedForSend}/$addressForSend");

              // uncomment below to send to the server 
              // FetchLocation(dataToSend);
            }
          });
        });
      } else {
        print('Chceck the permissions!');
      }
    });
  }

  Stream<LocationModel> get locationStream => _streamLocationController.stream;

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
