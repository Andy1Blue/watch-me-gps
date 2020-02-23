import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class FetchLocation {
  FetchLocation(body) {
    _sendData(body);
  }

  void _sendData(body) async {
    await DotEnv().load('.env');
    print(DotEnv().env['URL_KEY']);

    Future<Response> request = post(
        '${DotEnv().env['FETCH_URL']}?myykey=${DotEnv().env['URL_KEY']}',
        body: body);
    request.then((req) {
      print('${req.statusCode}: ${req.body}');
    });
  }
}
