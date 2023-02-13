import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/homepages/association/request_received.dart';
import 'package:pullventure_flutter/homepages/association/request_sent.dart';

class PendingRequest extends StatefulWidget {
  final String type;
  final String email;

  const PendingRequest({super.key, required this.type, required this.email});

  @override
  State<PendingRequest> createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  Map<String, String> downloadUrls = {};
  Stream? pendingRequestStream;
  int selectedIndex = 0;
  TabBar tabBar = const TabBar(
    labelColor: Colors.black,
    tabs: [
      Tab(
        text: "Sent",
      ),
      Tab(
        text: "Received",
      ),
    ],
  );


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
                          child: downloadUrls['${url}_photo'] == null
                              ? const Icon(Icons.account_circle, size: 50)
                              : Image.network(
                                  downloadUrls['${url}_photo'] ?? '',
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
                    list.docs[index]['sender'] == widget.email
                        ? TextButton(
                            onPressed: () {}, child: const Text("Withdraw"))
                        : Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.check)),
                              ),
                              const SizedBox(width: 15.0),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.close)),
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
    return DefaultTabController(
      length: 2,
      initialIndex: selectedIndex,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Pending Requests"),
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            titleTextStyle:
                const TextStyle(color: Colors.black, fontSize: 20.0),
            iconTheme: const IconThemeData(color: Colors.black),
            bottom: tabBar,
          ),
          body: TabBarView(children: [
            RequestSent(
              email: widget.email,
              type: widget.type,
            ),
            RequestReceived(
              email: widget.email,
              type: widget.type,
            ),
          ])),
    );
  }
}
