import 'package:flutter_sms/flutter_sms_platform.dart';
// import 'package:sms/sms.dart';

class SendSms {
  SendSms(String message, List<String> recipents) {
    _sendSMS(message, recipents);
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await FlutterSmsPlatform()
        .sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
