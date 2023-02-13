import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/homepages/chatscreen/chat_screen.dart';
import 'package:pullventure_flutter/model/Constants.dart';
import 'package:pullventure_flutter/model/investor_model.dart';
import 'package:readmore/readmore.dart';

class InvestorProfile extends StatefulWidget {
  final String imgUrl;
  final String email;
  final InvestorModel investorModel;

  const InvestorProfile(
      {super.key,
      required this.imgUrl,
      required this.investorModel,
      required this.email});

  @override
  State<InvestorProfile> createState() => _InvestorProfileState();
}

class _InvestorProfileState extends State<InvestorProfile> {
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String token = "";
  bool isFriend = false;
  bool isRequested = true;

  getToken() async {
    token = await dataBaseMethods.getUserTokenbyEmail(
        widget.investorModel.email!, "startup");
  }

  sendPushNotification(token, message, amount) async {
    try {
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var body = {
        'to': token,
        'notification': {
          'title': '${Constants.name} - STARTUP',
          'body': "INVESTED AMOUNT: $amount, $message",
          'android_channel_id': 'pullventure_chat'
        }
      };
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'key=AAAA6dZtjxA:APA91bE-FDq8IIiBe1oagOf1UqacOYHQ7FTpQighWyhbyr1KBCvNS50ixg-FdxFjaGGJvKNly2TS_Xg2y7_m5E1DE_2Q_cQeRiNOYrdbMm3t15PnWDNiJdEGipuESTa7xWLWpNYNBsBk'
      };
      var response = await post(url, headers: headers, body: jsonEncode(body));
      log(response.statusCode.toString());
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  createchatforconversation(String username, String email) {
    if (username != Constants.name) {
      String chatroomid = getchatroomid(username, Constants.name);
      List<String?> users = [username, Constants.name];
      List<String?> emails = [email, widget.email];
      Map<String, dynamic> chatroommap = {
        "users": users,
        "chatroomid": chatroomid,
        "emails": emails
      };
      dataBaseMethods.createChatroom(chatroomid, chatroommap, context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                  chatroomid: chatroomid,
                  user: username,
                  email: email,
                  type: "startup")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You cannot message yourself")));
    }
  }

  String getchatroomid(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_escapes
      return "$b\_$a";
    } else {
      // ignore: unnecessary_string_escapes
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    checkIfFriend();
  }

  checkIfFriend() async {
    isFriend = await dataBaseMethods.isFriend("startup",
        currentEmail: widget.email, email: widget.investorModel.email!);
    setState(() {
      isRequested = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.investorModel.name!}'s Profile"),
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          isRequested
              ? const CircularProgressIndicator()
              : !isFriend
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Send association request"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: "Enter invested amount",
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: messageController,
                                      maxLines: 5,
                                      decoration: const InputDecoration(
                                        hintText: "Enter your message",
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      dataBaseMethods.addFriendRequest(
                                          "startup", context,
                                          currentName: Constants.name!,
                                          name: widget.investorModel.name!,
                                          currentEmail: widget.email,
                                          email: widget.investorModel.email!,
                                          amount: amountController.text,
                                          message: messageController.text);
                                      sendPushNotification(
                                          token,
                                          messageController.text,
                                          amountController.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Send request"),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: Image.asset("assets/images/add-friend.png",
                          width: 25, height: 25),
                    )
                  : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipOval(
              child: Image.network(
                widget.imgUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.account_circle, size: 150),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.investorModel.name!,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("About",
                      style: TextStyle(
                        fontSize: 25.0,
                      ))),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "I am a software engineer and I love to code.",
                  )),
            ),
            const SizedBox(height: 40.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Investment Sector",
                      style: TextStyle(
                        fontSize: 25.0,
                      ))),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.investorModel.investmentSector!,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ))),
            ),
            const SizedBox(height: 40.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Experience",
                      style: TextStyle(
                        fontSize: 25.0,
                      ))),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      widget.imgUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.account_circle, size: 50),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Founder & CEO",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            widget.investorModel.companyName!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: ReadMoreText(
                            "• ${widget.investorModel.aboutCompany!}",
                            trimLines: 2,
                            colorClickableText: Colors.blue,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 117, 116, 116)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Email:"),
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.investorModel.email!,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 117, 116, 116)),
                  )),
            ),
            const SizedBox(height: 30.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Investments:",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => createchatforconversation(
              widget.investorModel.name!, widget.investorModel.email!),
          backgroundColor: Colors.amber[800],
          child: const Icon(Icons.message)),
    );
  }
}
