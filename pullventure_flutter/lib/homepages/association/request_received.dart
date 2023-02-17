import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';

class RequestReceived extends StatefulWidget {
  final String email;
  final String type;

  const RequestReceived({
    super.key,
    required this.email,
    required this.type,
  });

  @override
  State<RequestReceived> createState() => _RequestReceivedState();
}

class _RequestReceivedState extends State<RequestReceived> {
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  Map<String, String> downloadUrls = {};
  Stream? pendingRequestStream;
  bool checkLength = false;
  bool isLoading = true;

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
    setState(() {
      isLoading = false;
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
          String url = list.docs[index]['email'].toString();
          return list.docs[index]['email'] != list.docs[index]['sender']
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
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.account_circle,
                                                    size: 50),
                                      ),
                              ),
                              const SizedBox(width: 10.0),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  list.docs[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: IconButton(
                                    onPressed: () async {
                                      dataBaseMethods.acceptRequest(widget.type,
                                          currentEmail: widget.email,
                                          email: list.docs[index]['email']
                                              .toString());
                                    },
                                    icon: const Icon(Icons.check)),
                              ),
                              const SizedBox(width: 15.0),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: IconButton(
                                    onPressed: () async {
                                      dataBaseMethods.rejectRequest(widget.type,
                                          currentEmail: widget.email,
                                          email: list.docs[index]['email']
                                              .toString());
                                    },
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
                )
              : null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder(
            stream: pendingRequestStream,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                for (var element in (snapshot.data as QuerySnapshot).docs) {
                  if (element['sender'] == widget.email) {
                    setState(() {
                      checkLength = true;
                    });
                    break;
                  }
                }
                return checkLength
                    ? listView(snapshot.data)
                    : const Center(child: Text("No requests received"));
              } else {
                return Container();
              }
            }));
  }
}
