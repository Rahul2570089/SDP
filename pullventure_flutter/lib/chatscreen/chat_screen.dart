import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/encryption/abstract_encryption.dart';
import 'package:pullventure_flutter/encryption/encryption_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pullventure_flutter/model/Constants.dart';

class ChatScreen extends StatefulWidget {
  final String chatroomid;
  final String user;
  const ChatScreen({super.key, required this.chatroomid, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  TextEditingController textEditingController = TextEditingController();
  Stream? chatmsg;
  AbstractEncryption encryptionService = EncryptionService(encrypt.Encrypter(
      encrypt.AES(encrypt.Key.fromLength(32), padding: null)));

  sendMessages() {
    if (textEditingController.text.isNotEmpty) {
      Map<String, dynamic> msgmap = {
        "message": encryptionService.encrypt(textEditingController.text.trim()),
        "sender": Constants.name,
        "time": DateTime.now().minute >= 0 && DateTime.now().minute <= 9
            ? "${DateTime.now().hour}:${DateTime.now().minute}0"
            : "${DateTime.now().hour}:${DateTime.now().minute}",
        "timeOrder": DateTime.now().millisecondsSinceEpoch,
      };
      dataBaseMethods.addConversationMsg(widget.chatroomid, msgmap);
      textEditingController.text = "";
    }
  }

  Widget chatMessageTile(snapshot) {
    return ListView.builder(
        itemCount: (snapshot.data as QuerySnapshot).docs.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return MessageTile(
              encryptionService.decrypt(
                  (snapshot.data as QuerySnapshot).docs[index]["message"]),
              (snapshot.data as QuerySnapshot).docs[index]["sender"] ==
                  Constants.name,
              (snapshot.data as QuerySnapshot).docs[index]["time"]);
        });
  }

  @override
  void initState() {
    super.initState();
    dataBaseMethods.getConversationMsg(widget.chatroomid).then((val) {
      setState(() {
        chatmsg = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
      ),
      body: Stack(
        children: [
          StreamBuilder(
              stream: chatmsg,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return chatMessageTile(snapshot);
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No messages"),
                  );
                } else {
                  return const ScaffoldMessenger(
                      child: Text("Some error occured"));
                }
              }),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: const Color(0x54FFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: "Message",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  )),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: FloatingActionButton(
                      elevation: 0.0,
                      onPressed: () {
                        sendMessages();
                      },
                      backgroundColor: Colors.amber[800],
                      child: const Icon(
                        Icons.send,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String msg;
  final bool sender;
  final String time;
  const MessageTile(this.msg, this.sender, this.time, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(left: sender ? 0 : 10, right: sender ? 10 : 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: time.length.toDouble() * 15.5,
        ),
        decoration: BoxDecoration(
            color: sender ?Colors.amber[300] : Colors.amber[100],
            borderRadius: sender
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              msg,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Align(
              alignment: sender ? Alignment.topRight : Alignment.topLeft,
              child: Text(
                time,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
