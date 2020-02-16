import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:watch_me_gps/models/locationModel.dart';

class NoData extends StatelessWidget {
  const NoData({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('title'),
          backgroundColor: Colors.blueAccent,
        ),
        body: new ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('NO DATA'),
                      subtitle: Text('Address'),
                    )
                  ],
                ),
              )
            ]));
  }
}
