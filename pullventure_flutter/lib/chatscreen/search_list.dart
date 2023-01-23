import 'package:flutter/material.dart';
import 'package:pullventure_flutter/chatscreen/homescreen_chat.dart';
import 'package:pullventure_flutter/database/database_methods.dart';

class SearchList extends StatefulWidget {
  final String type;
  const SearchList({super.key, required this.type});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  TextEditingController searchController = TextEditingController();
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  List<Map<String, dynamic>> searchList = [];
  bool isLoading = true;

  getUser() async {
    if (widget.type == "investor") {
      searchList = await dataBaseMethods.getAllStartups();
    } else {
      searchList = await dataBaseMethods.getAllInvestors();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget listView(list) {
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
              children: [
                Text(
                  list['name'],
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  list['email'],
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
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading ? const CircularProgressIndicator() : Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: TextField(
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
            child: ListView.builder(
                itemCount: searchList.length,
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
                      child: listView(searchList[index]));
                }),
          ))
        ],
      ),
    );
  }
}
