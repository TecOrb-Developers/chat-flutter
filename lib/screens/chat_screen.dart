import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.call,
        //       color: primaryColor,
        //     ),
        //   ),
        // ],
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
                              msg.msgType == "text"
                                  ? Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 7),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: isSender
                                              ? senderBoxColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          msg.message.toString(),
                                          style: TextStyle(
                                              color: isSender
                                                  ? Colors.white
                                                  : const Color(0xEE303030),
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  : Flexible(
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 350,
                                          maxHeight: 300,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: isSender
                                                ? senderBoxColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Image.network(
                                            msg.message.toString(),
                                          ),
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
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => SendImagePage(
                                      firebaseUser: widget.firebaseUser,
                                      targetUser: widget.targetUser,
                                      chatroom: widget.chatroom)),
                            );
                          },
                          icon: const Icon(
                            Icons.photo,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: sendTextMessage,
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

  void sendTextMessage() {
    String message = _textEditingController.text.trim();

    _textEditingController.clear();

    // widget.targetUser;

    if (message.isNotEmpty) {
      MessageModel messageModel = MessageModel(
          messageid: UUID.uuid.v1(),
          senderId: widget.firebaseUser.uid,
          senderEmail: widget.firebaseUser.email,
          receiverId: widget.targetUser.uid,
          receiverEmail: widget.targetUser.email,
          createdon: DateTime.now(),
          message: message,
          msgType: "text");

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

class SendImagePage extends StatefulWidget {
  final User firebaseUser;
  final UserModel targetUser;
  final ChatroomModel chatroom;
  const SendImagePage({
    Key? key,
    required this.firebaseUser,
    required this.targetUser,
    required this.chatroom,
  }) : super(key: key);

  @override
  State<SendImagePage> createState() => _SendImagePageState();
}

class _SendImagePageState extends State<SendImagePage> {
  File? image;
  @override
  void initState() {
    pickImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          if (image != null)
            Image.file(
              image!,
              height: 300,
            ),
          const Spacer(flex: 2),
          if (image != null)
            GestureDetector(
              onTap: (image != null)
                  ? () async {
                      try {
                        print("send");
                        final cloudinary =
                            CloudinaryPublic("janadeliveries", "jana-react");

                        final response =
                            await cloudinary.uploadFile(CloudinaryFile.fromFile(
                          image!.path,
                          resourceType: CloudinaryResourceType.Image,
                        ));

                        print(response.url);

                        if (response.url.isNotEmpty) {
                          MessageModel messageModel = MessageModel(
                              messageid: UUID.uuid.v1(),
                              senderId: widget.firebaseUser.uid,
                              senderEmail: widget.firebaseUser.email,
                              receiverId: widget.targetUser.uid,
                              receiverEmail: widget.targetUser.email,
                              createdon: DateTime.now(),
                              message: response.url.toString(),
                              msgType: "image");

                          FirebaseFirestore.instance
                              .collection("chatrooms")
                              .doc(widget.chatroom.chatroomId)
                              .collection("messages")
                              .doc(messageModel.messageid)
                              .set(messageModel.toMap());
                        }

                        Navigator.pop(context);
                      } on CloudinaryException catch (e) {
                        print(e.message);
                      } on SocketException catch (e) {
                        print(e.message);
                        print(e.osError);
                      }
                    }
                  : null,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    color: primaryColor,
                    shape: StadiumBorder(),
                  ),
                  child: const Text(
                    "SEND",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? xImage = await picker.pickImage(source: ImageSource.gallery);

      if (xImage == null) {
        Navigator.pop(context);
        return;
      }

      final imageTemp = File(xImage.path);

      image = imageTemp;

      if (image != null) {
        setState(() {
          print("image exists");
        });
      }

      // print("response url: ${response.url}");
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
