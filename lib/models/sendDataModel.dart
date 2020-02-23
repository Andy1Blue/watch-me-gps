
class SendDataModel {
  final String user;
  final String location;
  final String data;
  final String other;

  SendDataModel({this.user, this.location, this.data, this.other});

  factory SendDataModel.fromJson(Map<String, dynamic> json) {
    return SendDataModel(
      user: json['user'],
      location: json['location'],
      data: json['data'],
      other: json['other'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["user"] = user;
    map["location"] = location;
    map["data"] = data;
    map["other"] = other;

    return map;
  }
}