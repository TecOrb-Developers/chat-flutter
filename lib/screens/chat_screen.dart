import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/model/chat_room_model.dart';
import 'package:new_project/model/meassage_model.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/utils/uuid.dart';

class ChatScreen extends StatefulWidget {
  final UserModel targetUser;
  final ChatroomModel chatroom;
  // final UserModel userModel;
  final User firebaseUser;

  const ChatScreen(
      {super.key,
      required this.targetUser,
      required this.chatroom,
      required this.firebaseUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: primaryColor,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: hintTextColor,
              backgroundImage: NetworkImage(widget.targetUser.photoUrl ?? ""),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(
              widget.targetUser.name ?? "",
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatroom.chatroomId)
                    .collection("messages")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot docSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemCount: docSnapshot.docs.length,
                        itemBuilder: ((context, index) {
                          MessageModel msg = MessageModel.fromMap(
                              docSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          bool isSender =
                              (msg.senderId == widget.firebaseUser.uid);
                          return Row(
                            mainAxisAlignment: isSender
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 7),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isSender
                                        ? senderBoxColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    msg.text.toString(),
                                    style: TextStyle(
                                        color: isSender
                                            ? Colors.white
                                            : const Color(0xEE303030),
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: SizedBox.shrink());
                    } else {
                      return const Center(child: Text("Start new chat"));
                    }
                  } else {
                    return const Center(
                      child: Text("Loading your chat"),
                    );
                  }
                }),
              ),
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(top: 6, left: 10, bottom: 10),
                    // height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                              controller: _textEditingController,
                              maxLines: null,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              cursorColor: primaryColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type your message...",
                                hintStyle: TextStyle(color: Colors.grey),
                              )),
                        ),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: const Icon(
                        //     Icons.camera_alt_rounded,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void sendMessage() {
    String message = _textEditingController.text.trim();

    _textEditingController.clear();

    widget.targetUser;

    if (message.isNotEmpty) {
      MessageModel messageModel = MessageModel(
        messageid: UUID.uuid.v1(),
        senderId: widget.firebaseUser.uid,
        senderEmail: widget.firebaseUser.email,
        receiverId: widget.targetUser.uid,
        receiverEmail: widget.targetUser.email,
        createdon: DateTime.now(),
        text: message,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomId)
          .collection("messages")
          .doc(messageModel.messageid)
          .set(messageModel.toMap());
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}










// Stack(children: [
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             height: 60,
//             alignment: Alignment.center,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 const Expanded(
//                   child: TextField(
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                       cursorColor: primaryColor,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Type your message...",
//                         hintStyle: TextStyle(color: Colors.grey),
//                       )),
//                 ),
//                 IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.camera_alt_rounded,
//                       color: Colors.grey,
//                     ))
//               ],
//             ),
//           ),
//         )
//       ]),
    