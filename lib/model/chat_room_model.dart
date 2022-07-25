class ChatroomModel {
  String? chatroomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatroomModel({this.chatroomId, this.participants, this.lastMessage});

  static ChatroomModel fromMap(Map<String, dynamic> map) => ChatroomModel(
        chatroomId: map["chatroomId"],
        participants: map["participants"],
        lastMessage: map["lastMessage"],
      );

  Map<String, dynamic> toMap() => {
        "chatroomId": chatroomId,
        "participants": participants,
        "lastMessage": lastMessage,
      };
}
