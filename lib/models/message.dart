class MessageModel {
  String? id;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createAt;

  MessageModel({this.id, this.sender, this.text, this.seen, this.createAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? '';
    sender = json["sender"]?? '';
    text = json["text"]?? '';
    seen = json["seen"]?? '';
    createAt = json["createdAt"].toDate() ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdAt": createAt,
    };
  }
}