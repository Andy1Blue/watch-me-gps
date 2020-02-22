import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:watch_me_gps/utils/storage.dart';

class Setting extends StatefulWidget {
  const Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void initState() {
    super.initState();
    setData();
  }

  TextEditingController controller = TextEditingController();

  Future<bool> saveData(nameKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nameKey, controller.text);
  }

  Future<String> loadData(nameKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  setData() {
    loadData('phoneNumber').then((value) {
      setState(() {
        controller.text = value;
      });
    });
  }

  Widget build(BuildContext context) {
    var phoneNumber = '';

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            Text('$phoneNumber'),
            TextField(
              decoration: InputDecoration(labelText: 'Enter your username'),
              controller: controller,
              onTap: () {
                controller.clear();
              },
            ),
            RaisedButton(
                onPressed: () {
                  saveData('phoneNumber');
                },
                textColor: Colors.white,
                color: Colors.red,
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Save String",
                )),
          ],
        ),
      ),
    );
  }
}
