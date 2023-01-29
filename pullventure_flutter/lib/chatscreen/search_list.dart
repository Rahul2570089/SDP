import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/chatscreen/chat_screen.dart';
import 'package:pullventure_flutter/chatscreen/homescreen_chat.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/model/Constants.dart';
import 'package:pullventure_flutter/model/investor_model.dart';
import 'package:pullventure_flutter/model/startup_model.dart';

class SearchList extends StatefulWidget {
  final String type;
  final String token;
  const SearchList({super.key, required this.type, required this.token});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  TextEditingController searchController = TextEditingController();
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  QuerySnapshot? snapshot;
  List<InvestorModel> searchListInvestor = [], filterListInvestor = [];
  List<StartUpModel> searchListStartup = [], filterListStartup = [];
  bool isLoading = true;
  bool show = false;

  getUser() async {
    if (widget.type == "investor") {
      final temp = await dataBaseMethods.getAllStartups();
      for (var element in temp) {
        searchListStartup.add(StartUpModel(
            name: element['name'],
            email: element['email'],
            headquarters: element['headquarters'],
            description: element['description'],
            sector: element['sector']));
      }
    } else {
      final temp = await dataBaseMethods.getAllInvestors();
      for (var element in temp) {
        searchListInvestor.add(InvestorModel(
            name: element['name'],
            email: element['email'],
            mobileNumber: element['mobilenumber'],
            investmentSector: element['investmentsector'],
            companyName: element['companyname'],
            aboutCompany: element['aboutcompany']));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  createchatforconversation(String username) {
    if (username != Constants.name) {
      String chatroomid = getchatroomid(username, Constants.name);
      List<String?> users = [username, Constants.name];
      Map<String, dynamic> chatroommap = {
        "users": users,
        "chatroomid": chatroomid
      };
      dataBaseMethods.createChatroom(chatroomid, chatroommap, context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChatScreen(chatroomid: chatroomid, user: username, token: widget.token,)));
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
    getUser();
  }

  Widget listView(list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => createchatforconversation(list[index].name),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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
                          list[index].name,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          list[index].email,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.type == 'investor'
            ? const Text('Search start-ups')
            : const Text('Search investors'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: TextField(
                    onChanged: ((value) => {
                          setState(() {
                            if (widget.type == 'investor') {
                              filterListStartup = searchListStartup
                                  .where((element) =>
                                      element.name!.contains(value))
                                  .toList();
                            } else if (widget.type == 'startup') {
                              filterListInvestor = searchListInvestor
                                  .where((element) =>
                                      element.name!.contains(value))
                                  .toList();
                            }
                            show = true;
                            if (value.isEmpty) show = false;
                          })
                        }),
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ScrollConfiguration(
                        behavior: CustomBehavior(),
                        child: !show
                            ? listView(widget.type == 'investor'
                                ? searchListStartup
                                : searchListInvestor)
                            : listView(widget.type == 'investor'
                                ? filterListStartup
                                : filterListInvestor)))
              ],
            ),
    );
  }
}
