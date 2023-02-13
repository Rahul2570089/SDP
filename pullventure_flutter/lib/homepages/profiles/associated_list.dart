import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';

class AssociatedList extends StatefulWidget {
  final String type;
  final String email;
  final Map<String, dynamic> downloadUrls;

  const AssociatedList(
      {super.key,
      required this.type,
      required this.email,
      required this.downloadUrls});

  @override
  State<AssociatedList> createState() => _AssociatedListState();
}

class _AssociatedListState extends State<AssociatedList> {
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  Stream? chatroom;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    dataBaseMethods.getFriends(widget.type, widget.email).then((value) {
      setState(() {
        chatroom = value;
        isLoading = false;
      });
    });
  }

  Widget listView(list) {
    return ListView.builder(
        itemCount: (list as QuerySnapshot).docs.length,
        itemBuilder: (context, index) {
          String url = (list).docs[index]['email'].toString();
          return Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: widget.downloadUrls['${url}_photo'] == null
                              ? const Icon(Icons.account_circle, size: 50)
                              : Image.network(
                                  widget.downloadUrls['${url}_photo'] ?? '',
                                  width: 50.0,
                                  height: 50.0,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.account_circle,
                                          size: 50),
                                ),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          list.docs[index]['name'],
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Associated ${widget.type == "investor" ? "startups" : "investors"}'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder(
        stream: chatroom,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return listView(snapshot.data);
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No associations"),
            );
          } else {
            return const ScaffoldMessenger(child: Text("Some error occured"));
          }
        },
      ),
    );
  }
}
