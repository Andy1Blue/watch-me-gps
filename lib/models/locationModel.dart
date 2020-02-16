import 'package:watch_me_gps/models/addressModel.dart';

class LocationModel {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final AddressModel address;
  final DateTime timestamp;

  LocationModel(
      {this.latitude,
      this.longitude,
      this.altitude,
      this.speed,
      this.address,
      this.timestamp});
}
