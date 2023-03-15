import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/auth/authenticate.dart';
import 'package:pullventure_flutter/homepages/association/pending_request.dart';
import 'package:pullventure_flutter/homepages/chatscreen/chat_list.dart';
import 'package:pullventure_flutter/homepages/chatscreen/chat_screen.dart';
import 'package:pullventure_flutter/homepages/chatscreen/search_list.dart';
import 'package:pullventure_flutter/homepages/government_schemes/government_schemes.dart';
import 'package:pullventure_flutter/homepages/news/news.dart';
import 'package:pullventure_flutter/homepages/profiles/associated_list.dart';
import 'package:pullventure_flutter/homepages/profiles/investor_self.dart';
import 'package:pullventure_flutter/homepages/profiles/startup_self.dart';
import 'package:pullventure_flutter/main.dart';
import 'package:pullventure_flutter/model/Constants.dart';
import 'package:pullventure_flutter/database/database_methods.dart';

class ChatHomeScreen extends StatefulWidget {
  final String email;
  final String type;
  const ChatHomeScreen({super.key, required this.type, required this.email});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  int currentIndex = 0;
  TextEditingController searchController = TextEditingController();
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  List<Map<String, dynamic>> searchChat = [];
  Map<String, String> downloadUrls = {};
  Stream? chatroom;
  bool showSearchList = false;
  int popUpVal = 0;
  FirebaseMessaging message = FirebaseMessaging.instance;

  @override
  void initState() {
    getuserinfo();
    super.initState();
  }

  getFirebaseMessagingToken() async {
    await message.requestPermission();

    await message.getToken().then((value) {
      if (value != null) {
        dataBaseMethods.updateInvestorWithToken(
            value, widget.email, widget.type);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  getuserinfo() async {
    await getFirebaseMessagingToken();
    dataBaseMethods.getChatRoom(Constants.name).then((value) {
      setState(() {
        chatroom = value;
      });
    });

    await dataBaseMethods
        .getAllLogos(widget.type == "investor" ? "startups" : "investors")
        .then((value) {
      setState(() {
        downloadUrls = value;
      });
    });
  }

  Widget listView(list, isList) {
    return ListView.builder(
        itemCount: isList ? list.length : (list as QuerySnapshot).docs.length,
        itemBuilder: (context, index) {
          String url = widget.email ==
                  (list).docs[index]['emails'][0].toString().split("_")[0]
              ? (list).docs[index]['emails'][1].toString().split("_")[0]
              : (list).docs[index]['emails'][0].toString().split("_")[0];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            user: (list as QuerySnapshot)
                                .docs[index]["chatroomid"]
                                .toString()
                                .replaceAll("_", "")
                                .replaceAll(Constants.name!, ""),
                            email:
                                widget.email == (list).docs[index]['emails'][0]
                                    ? (list).docs[index]['emails'][1]
                                    : (list).docs[index]['emails'][0],
                            chatroomid: (list).docs[index]["chatroomid"],
                            type: widget.type,
                          )));
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: downloadUrls['${url}_photo'] == null
                            ? const Icon(Icons.account_circle, size: 50)
                            : Image.network(
                                downloadUrls['${url}_photo'] ?? '',
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.account_circle, size: 50),
                              ),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isList
                                ? "Name $index"
                                : (list as QuerySnapshot)
                                    .docs[index]["chatroomid"]
                                    .toString()
                                    .replaceAll("_", "")
                                    .replaceAll(Constants.name!, ""),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    indent: 55,
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.type == "startup" ? "Investors list" : "Startups list"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          PopupMenuButton(
              position: PopupMenuPosition.under,
              onSelected: (value) {
                if (value == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.type == "startup"
                            ? SelfProfileStartUp(
                                email: widget.email,
                              )
                            : SelfProfileInvestor(email: widget.email),
                      ));
                }
                if (value == 3) {
                  AuthMethod.signout(context);
                  Constants.name = "";
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ));
                } else if (value == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingRequest(
                            type: widget.type, email: widget.email),
                      ));
                } else if (value == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssociatedList(
                            type: widget.type,
                            email: widget.email,
                            downloadUrls: downloadUrls),
                      ));
                }
              },
              icon: const Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      onTap: () {},
                      value: 0,
                      child: const Text("View profile")),
                  PopupMenuItem(
                      onTap: () {},
                      value: 1,
                      child: const Text("View pending requests")),
                  PopupMenuItem(
                      onTap: () {},
                      value: 2,
                      child: Text(
                          "Associated ${widget.type == "investor" ? "startups" : "investors"}")),
                  PopupMenuItem(
                      onTap: () {}, value: 3, child: const Text("Sign out")),
                ];
              })
        ],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label:
                widget.type == "startup" ? "Investors list" : "Startups list",
            tooltip:
                widget.type == "startup" ? "Investors list" : "Startups list",
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.newspaper), label: 'News', tooltip: 'News'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.schema_outlined),
            label: 'Government schemes',
            tooltip: 'Government schemes',
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.event), label: 'Events', tooltip: 'Events'),
        ],
        onTap: (value) => setState(() => currentIndex = value),
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber[800],
      ),
      body: currentIndex == 1
          ? const News()
          // : currentIndex == 3
          //     ? const Events()
          : currentIndex == 2
              ? const GovernmentSchemes()
              : SearchList(type: widget.type, email: widget.email),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatList(type: widget.type, email: widget.email)));
              },
              backgroundColor: Colors.amber[800],
              child: const Icon(Icons.message_rounded),
            )
          : null,
    );
  }
}

class CustomBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
