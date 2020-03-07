import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:watch_me_gps/models/sendDataModel.dart';

class FetchLocation {
  FetchLocation(SendDataModel body) {
    _sendData(body.toMap());
  }

  void _sendData(body) async {
    await DotEnv().load('.env');

    Future<Response> request = post(
        '${DotEnv().env['FETCH_URL']}?myykey=${DotEnv().env['URL_KEY']}',
        body: body);

    request.then((req) {
      print('${req.statusCode}: ${req.body}');
    });
  }
}
