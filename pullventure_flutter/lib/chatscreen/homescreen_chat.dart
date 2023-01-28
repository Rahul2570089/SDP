import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/chatscreen/chat_screen.dart';
import 'package:pullventure_flutter/chatscreen/search_list.dart';
import 'package:pullventure_flutter/main.dart';
import 'package:pullventure_flutter/model/Constants.dart';
import 'package:pullventure_flutter/database/database_methods.dart';

class ChatHomeScreen extends StatefulWidget {
  final String name;
  final String type;
  const ChatHomeScreen({super.key, required this.type, required this.name});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  int currentIndex = 0;
  TextEditingController searchController = TextEditingController();
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  List<Map<String, dynamic>> searchChat = [];
  Stream? chatroom;
  bool showSearchList = false;
  int popUpVal = 0;

  @override
  void initState() {
    getuserinfo();
    super.initState();
  }

  getuserinfo() async {
    // constants.name= (await helpermethod.getusernameloggedinsharedpreference());
    dataBaseMethods.getChatRoom(Constants.name).then((value) {
      setState(() {
        chatroom = value;
      });
    });
  }

  Widget listView(list, isList) {
    return ListView.builder(
        itemCount: isList ? list.length : (list as QuerySnapshot).docs.length,
        itemBuilder: (context, index) {
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
                          chatroomid: (list).docs[index]["chatroomid"])));
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
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(50.0),
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
                          Text(
                            'Last message $index',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
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
        title: const Text('Chat Screen'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          PopupMenuButton(
              position: PopupMenuPosition.under,
              onSelected: (value) {
                if (value == 1) {
                  Constants.name = "";
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
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
                      onTap: () {}, value: 0, child: const Text("View profile")),
                  PopupMenuItem(onTap: () {}, value: 1, child: const Text("Sign out")),
                ];
              })
        ],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Chat',
            tooltip: 'Chat',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper), label: 'News', tooltip: 'News'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: 'Events', tooltip: 'Events'),
          BottomNavigationBarItem(
            icon: Icon(Icons.schema_outlined),
            label: 'Government schemes',
            tooltip: 'Government schemes',
          ),
        ],
        onTap: (value) => setState(() => currentIndex = value),
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber[800],
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
              onChanged: (value) async {},
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
                      return !showSearchList
                          ? listView(snapshot.data, false)
                          : listView(searchChat, true);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchList(
                        type: widget.type,
                      )));
        },
        backgroundColor: Colors.amber[800],
        child: const Icon(Icons.search),
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
