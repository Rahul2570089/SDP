import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';

class RequestSent extends StatefulWidget {
  final String email;
  final String type;

  const RequestSent({
    super.key,
    required this.email,
    required this.type,
  });

  @override
  State<RequestSent> createState() => _RequestSentState();
}

class _RequestSentState extends State<RequestSent> {
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  Map<String, String> downloadUrls = {};
  Stream? pendingRequestStream;
  List list1 = [];

  getPendingRequest() async {
    pendingRequestStream =
        await dataBaseMethods.getFriendRequests(widget.type, widget.email);

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

  @override
  void initState() {
    super.initState();
    getPendingRequest();
  }

  Widget listView(list) {
    return ListView.builder(
        itemCount: (list as QuerySnapshot).docs.length,
        itemBuilder: (context, index) {
          String url = (list).docs[index]['email'].toString();
          return list.docs[index]['sender'] == widget.email
              ? Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
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
                                        errorBuilder:
                                            (context, error, stackTrace) =>
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
                          TextButton(
                              onPressed: () {
                                dataBaseMethods.withdrawRequest(widget.type,
                                    currentEmail: widget.email,
                                    email: list.docs[index]['email']);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Request withdrawn"),
                                  ),
                                );
                              },
                              child: const Text("Withdraw"))
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        indent: 55,
                      )
                    ],
                  ),
                )
              : null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: pendingRequestStream,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            for (var element in (snapshot.data as QuerySnapshot).docs) {
              if (element['sender'] == widget.email) {
                list1.add(element);
              }
            }
            if (list1.isEmpty) {
              return const Center(
                child: Text("No requests sent"),
              );
            }
            return listView(list1);
          } else {
            return Container();
          }
        }));
  }
}
