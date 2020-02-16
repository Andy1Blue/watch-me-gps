import 'package:watch_me_gps/models/addressModel.dart';

class LocationModel {
  final bool isServiceEnabled;
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final AddressModel address;

  LocationModel(
      {this.isServiceEnabled,this.latitude, this.longitude, this.altitude, this.speed, this.address});
}
