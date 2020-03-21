import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_me_gps/services/sharedPreferencesService.dart';

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
    SharedPreferencesService().loadStringData('userName').then((userName) {
      setState(() {
        userNameTextcontroller.text = userName;
      });
    });

    SharedPreferencesService()
        .loadStringData('phoneNumber')
        .then((phoneNumber) {
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
                  child: new Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    var cardSettingData = [
      {
        'usernameField': 'Enter your username',
        'controllerName': userNameTextcontroller,
        'icon': Icons.person
      },
      {
        'usernameField': 'Enter phone number for alerts',
        'controllerName': phoneNumberTextcontroller,
        'icon': Icons.phone
      },
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cardSettingData.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0),
                  child: Card(
                    color: Color.fromRGBO(64, 75, 96, 1.0),
                    elevation: 2,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: RichText(
                            text: TextSpan(
                              text:
                                  '${cardSettingData[index]['usernameField']}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 22.0),
                                child: Icon(
                                  cardSettingData[index]['icon'],
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding:
                                    EdgeInsets.only(right: 30.0, bottom: 6),
                                child: TextField(
                                  maxLength: 20,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  cursorWidth: 3,
                                  decoration: InputDecoration(
                                    // labelText: 'Enter your username',
                                    labelStyle: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white54,
                                      height: 10,
                                    ),
                                    helperStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                    fillColor: Color.fromRGBO(58, 66, 86, 1.0),
                                    filled: true,
                                    border: InputBorder.none,
                                  ),
                                  controller: cardSettingData[index]
                                      ['controllerName'],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  child: Icon(Icons.save),
                  backgroundColor: Colors.black87,
                  onPressed: () {
                    SharedPreferencesService().saveStringData(
                        'userName', userNameTextcontroller.text);
                    SharedPreferencesService().saveStringData(
                        'phoneNumber', phoneNumberTextcontroller.text);
                    _showDialog();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
