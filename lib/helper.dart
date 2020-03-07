import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Helper {
  void checkPermissions() async {
    if (await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.location) !=
        PermissionStatus.granted) {
      await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    }

    if (await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.locationAlways) !=
        PermissionStatus.granted) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    if (await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.phone) !=
        PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.phone]);
    }

    if (await PermissionHandler().checkPermissionStatus(PermissionGroup.sms) !=
        PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.sms]);
    }
  }

  AlertDialog loader(String title) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: new Text("$title",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      content: Container(
        child: SizedBox(
          width: 40.0,
          height: 40.0,
          child: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                strokeWidth: 5.0),
          ),
        ),
      ),
    );
  }

  void openAppSettings() async {
    await PermissionHandler().openAppSettings();
  }

  double round(number) {
    return num.parse(number.toStringAsFixed(1));
  }

  double msToKmh(double ms) {
    return round(ms * 3.6);
  }

  String setLongAdressText(location) {
    var addressText;

    if (location?.address?.postalCode != null) {
      addressText = '';
      if (location.address.postalCode != '') {
        addressText += location.address.postalCode + ' ';
      }
      if (location.address.locality != '') {
        addressText += location.address.locality + ' ';
      }
      if (location.address.thoroughfare != '') {
        addressText += location.address.thoroughfare + ' ';
      }
      if (location.address.subThoroughfare != '') {
        addressText += location.address.subThoroughfare + ' ';
      }
      if (location.address.country != '') {
        addressText += location.address.country + ' ';
      }
    }

    return addressText;
  }

  String setShortAdressText(location) {
    var addressText;

    if (location?.address?.postalCode != null) {
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

    return addressText;
  }
}
