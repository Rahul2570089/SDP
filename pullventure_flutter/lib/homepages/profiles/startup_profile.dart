import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/homepages/chatscreen/chat_screen.dart';
import 'package:pullventure_flutter/model/Constants.dart';
import 'package:pullventure_flutter/model/startup_model.dart';
import 'package:readmore/readmore.dart';

class StartupProfile extends StatefulWidget {
  final String imgUrl;
  final String email;
  final StartUpModel startupModel;

  const StartupProfile(
      {super.key, required this.startupModel, required this.imgUrl, required this.email});

  @override
  State<StartupProfile> createState() => _StartupProfileState();
}

class _StartupProfileState extends State<StartupProfile> {

  DatabaseMethods dataBaseMethods = DatabaseMethods();


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
                  type: "investor")));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.startupModel.name!}'s Profile"),
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.imgUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.account_circle, size: 150),
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.startupModel.name!,
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
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ReadMoreText(
                  widget.startupModel.description!,
                  trimLines: 2,
                  colorClickableText: Colors.blue,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 117, 116, 116)),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Company Sector",
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
                  child: Text(widget.startupModel.sector!,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 117, 116, 116)))),
            ),
            const SizedBox(height: 40.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Funding raised",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Details",
                      style: TextStyle(
                        fontSize: 25.0,
                      ))),
            ),
            const SizedBox(height: 15.0),
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
                    widget.startupModel.email!,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 117, 116, 116)),
                  )),
            ),
            const SizedBox(height: 15.0),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Headquarters:"),
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.startupModel.headquarters!,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 117, 116, 116)),
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => createchatforconversation(
              widget.startupModel.name!, widget.startupModel.email!),
          backgroundColor: Colors.amber[800],
          child: const Icon(Icons.message)),
    );
  }
}
