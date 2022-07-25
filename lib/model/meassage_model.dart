class MessageModel {
  String? messageid;
  String? senderId;
  String? senderEmail;
  String? receiverId;
  String? receiverEmail;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel(
      {this.messageid,
      this.senderId,
      this.senderEmail,
      this.receiverId,
      this.receiverEmail,
      this.text,
      this.seen = false,
      this.createdon});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    senderId = map["senderId"];
    senderEmail = map["senderEmail"];
    receiverId = map["receiverId"];
    receiverEmail = map["receiverEmail"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "senderId": senderId,
      "senderEmail": senderEmail,
      "receiverId": receiverId,
      "receiverEmail": receiverEmail,
      "text": text,
      "seen": seen,
      "createdon": createdon
    };
  }
}
