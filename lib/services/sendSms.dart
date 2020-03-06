import 'package:flutter/services.dart';
import 'package:sms_maintained/sms.dart';

class SendSms {
  SendSms(String message, List<String> recipents) {
    SmsQuery query = new SmsQuery();
    try {
      SmsSender sender = new SmsSender();
      String address = recipents[0];

      sender.sendSms(new SmsMessage(address, message));
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}
