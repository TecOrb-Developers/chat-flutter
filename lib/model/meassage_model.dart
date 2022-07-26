class MessageModel {
  String? messageid;
  String? senderId;
  String? senderEmail;
  String? receiverId;
  String? receiverEmail;
  String? message;
  String? msgType;
  bool? seen;
  DateTime? createdon;

  MessageModel(
      {this.messageid,
      this.senderId,
      this.senderEmail,
      this.receiverId,
      this.receiverEmail,
      this.message,
      this.msgType,
      this.seen = false,
      this.createdon});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    senderId = map["senderId"];
    senderEmail = map["senderEmail"];
    receiverId = map["receiverId"];
    receiverEmail = map["receiverEmail"];
    message = map["message"];
    msgType = map["msgType"];
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
      "message": message,
      "msgType": msgType,
      "seen": seen,
      "createdon": createdon
    };
  }
}
