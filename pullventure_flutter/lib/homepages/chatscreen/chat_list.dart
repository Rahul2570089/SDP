import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/homepages/chatscreen/chat_screen.dart';
import 'package:pullventure_flutter/model/Constants.dart';
import 'package:pullventure_flutter/model/investor_model.dart';
import 'package:pullventure_flutter/model/startup_model.dart';

class ChatList extends StatefulWidget {
  final String type;
  final String email;
  const ChatList({super.key, required this.type, required this.email});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int currentIndex = 0;
  TextEditingController searchController = TextEditingController();
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  static Map<String, String> downloadUrls = {};
  static List<InvestorModel> searchListInvestor = [], filterListInvestor = [];
  static List<StartUpModel> searchListStartup = [], filterListStartup = [];
  Stream? chatroom;
  bool show = false;
  int popUpVal = 0;
  FirebaseMessaging message = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    getuserinfo();
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
      if (mounted) {
        setState(() {
          downloadUrls = value;
        });
      }
    });
  }

  Widget listView(list, isList) {
    return ListView.builder(
        itemCount: isList ? list.length : (list as QuerySnapshot).docs.length,
        itemBuilder: (context, index) {
          String url;
          if (isList) {
            url = widget.email == list[index].email
                ? list[index].email
                : list[index].email;
          } else {
            url = widget.email ==
                    (list).docs[index]['emails'][0].toString().split("_")[0]
                ? (list).docs[index]['emails'][1].toString().split("_")[0]
                : (list).docs[index]['emails'][0].toString().split("_")[0];
          }
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            user: isList
                                ? list[index].name
                                : (list as QuerySnapshot)
                                    .docs[index]["chatroomid"]
                                    .toString()
                                    .replaceAll("_", "")
                                    .replaceAll(Constants.name!, ""),
                            email: isList
                                ? list[index].email
                                : widget.email ==
                                        (list).docs[index]['emails'][0]
                                    ? (list).docs[index]['emails'][1]
                                    : (list).docs[index]['emails'][0],
                            chatroomid: isList
                                ? "${list[index].name}_${Constants.name!}"
                                : (list).docs[index]["chatroomid"],
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              isList
                                  ? list[index].name
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
        title: const Text('Chat list'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
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
            child: TextField(
              controller: searchController,
              onChanged: ((value) => {
                    setState(() {
                      if (widget.type == 'investor') {
                        filterListStartup = searchListStartup
                            .where((element) => element.name!.contains(value))
                            .toList();
                      } else if (widget.type == 'startup') {
                        filterListInvestor = searchListInvestor
                            .where((element) => element.name!.contains(value))
                            .toList();
                      }
                      show = true;
                      if (value.isEmpty) show = false;
                    })
                  }),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
                behavior: CustomBehavior(),
                child: StreamBuilder(
                  stream: chatroom,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      if (widget.type == "startup") {
                        searchListInvestor = [];
                        for (int i = 0;
                            i < (snapshot.data as QuerySnapshot).docs.length;
                            i++) {
                          searchListInvestor.add(InvestorModel(
                            name: (snapshot.data as QuerySnapshot)
                                .docs[i]["chatroomid"]
                                .toString()
                                .replaceAll("_", "")
                                .replaceAll(Constants.name!, ""),
                            email: widget.email ==
                                    (snapshot.data as QuerySnapshot).docs[i]
                                        ['emails'][0]
                                ? (snapshot.data as QuerySnapshot).docs[i]
                                    ['emails'][1]
                                : (snapshot.data as QuerySnapshot).docs[i]
                                    ['emails'][0],
                          ));
                        }
                      } else if (widget.type == "investor") {
                        searchListStartup = [];
                        for (int i = 0;
                            i < (snapshot.data as QuerySnapshot).docs.length;
                            i++) {
                          searchListStartup.add(StartUpModel(
                            name: (snapshot.data as QuerySnapshot)
                                .docs[i]["chatroomid"]
                                .toString()
                                .replaceAll("_", "")
                                .replaceAll(Constants.name!, ""),
                            email: widget.email ==
                                    (snapshot.data as QuerySnapshot).docs[i]
                                        ['emails'][0]
                                ? (snapshot.data as QuerySnapshot).docs[i]
                                    ['emails'][1]
                                : (snapshot.data as QuerySnapshot).docs[i]
                                    ['emails'][0],
                          ));
                        }
                      }

                      return !show
                          ? listView(snapshot.data, false)
                          : listView(
                              widget.type == "startup"
                                  ? filterListInvestor
                                  : filterListStartup,
                              true);
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No chats"),
                      );
                    } else {
                      return const ScaffoldMessenger(
                          child: Text("Some error occured"));
                    }
                  },
                )),
          ),
        ],
      ),
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
