import 'package:flutter/services.dart';
import 'package:sms/sms.dart';

class Sms {
  Sms();

  Future<SmsMessage> send(String userMessage, List<String> recipents) async {
    // SmsQuery query = new SmsQuery();
    print('Sending SMS to ' + recipents[0]);

    SimCardsProvider provider = new SimCardsProvider();
    List<SimCard> card = await provider.getSimCards();
    SmsSender sender = new SmsSender();
    String address = recipents[0];

    SmsMessage message = new SmsMessage(address, userMessage);
    print(userMessage.length);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
     
    return sender.sendSms(message, simCard: card[0]);
  }
}
