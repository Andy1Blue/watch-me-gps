import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';
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

  TextEditingController userNameTextcontroller = TextEditingController();
  TextEditingController phoneNumberTextcontroller = TextEditingController();

  setData() {
    SharedPreferencesService().loadData('userName').then((userName) {
      setState(() {
        userNameTextcontroller.text = userName;
      });
    });
    SharedPreferencesService().loadData('phoneNumber').then((phoneNumber) {
      setState(() {
        phoneNumberTextcontroller.text = phoneNumber;
      });
    });
  }

  Widget build(BuildContext context) {
    var userName = '';

    void _showDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Settings have been saved!"),
              content: new Text(
                  "Actual setting:\nUsername: ${userNameTextcontroller.text}\nPhone number for alerts: ${phoneNumberTextcontroller.text}"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("oK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Enter your username'),
              controller: userNameTextcontroller,
              // onTap: () {
              // userNameTextcontroller.clear();
              // },
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Enter phone number for alerts'),
              controller: phoneNumberTextcontroller,
              // onTap: () {
              // phoneNumberTextcontroller.clear();
              // },
            ),
            RaisedButton(
                onPressed: () {
                  SharedPreferencesService()
                      .saveData('userName', userNameTextcontroller.text);
                  SharedPreferencesService()
                      .saveData('phoneNumber', phoneNumberTextcontroller.text);
                  _showDialog();
                },
                textColor: Colors.white,
                color: Colors.red,
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Save",
                )),
          ],
        ),
      ),
    );
  }
}
