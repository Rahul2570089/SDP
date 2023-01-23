import 'package:flutter/material.dart';
import 'package:pullventure_flutter/chatscreen/search_list.dart';
import 'package:pullventure_flutter/constants/constants.dart';
import 'package:pullventure_flutter/database/database_methods.dart';

class ChatHomeScreen extends StatefulWidget {
  final String type;
  const ChatHomeScreen({super.key, required this.type});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  int currentIndex = 0;
  TextEditingController searchController = TextEditingController();
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  Stream? chatroom;

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

  Widget listView() {
    return Column(
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
              children: const [
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Last message',
                  style: TextStyle(
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
    );
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
          IconButton(
            icon: const Icon(Icons.account_circle),
            splashRadius: 16,
            color: Colors.black,
            tooltip: 'View profile',
            onPressed: () {},
          ),
        ],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schema_outlined),
            label: 'Profile',
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
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (itemBuilder, index) {
                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: listView()
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchList(type: widget.type,)));
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
