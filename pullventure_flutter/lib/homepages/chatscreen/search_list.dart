import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/homepages/chatscreen/homescreen_chat.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/homepages/profiles/investor_profile.dart';
import 'package:pullventure_flutter/homepages/profiles/startup_profile.dart';
import 'package:pullventure_flutter/model/investor_model.dart';
import 'package:pullventure_flutter/model/startup_model.dart';

class SearchList extends StatefulWidget {
  final String type;
  final String email;
  const SearchList({super.key, required this.type, required this.email});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  TextEditingController searchController = TextEditingController();
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  QuerySnapshot? snapshot;
  List<InvestorModel> searchListInvestor = [], filterListInvestor = [];
  List<StartUpModel> searchListStartup = [], filterListStartup = [];
  Map<String, String> downloadUrls = {};
  bool isLoading = true;
  bool show = false;
  String token = "";

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
            aboutCompany: element['aboutcompany'],
            about: element['about'],
            companytitle: element['companytitle']));
      }
    }
    await dataBaseMethods
        .getAllLogos(widget.type == "investor" ? "startups" : "investors")
        .then((value) {
      setState(() {
        downloadUrls = value;
      });
    });
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
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        String url = list[index].email;
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => widget.type == 'investor'
                      ? StartupProfile(
                          imgUrl: downloadUrls['${url}_photo'] ?? '',
                          email: widget.email,
                          startupModel: list[index],
                        )
                      : InvestorProfile(
                          imgUrl: downloadUrls,
                          email: widget.email,
                          investorModel: list[index],
                        ))),
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
                    ClipOval(
                      child: downloadUrls['${url}_photo'] == ''
                          ? const Icon(Icons.account_circle, size: 50)
                          : Image.network(
                              downloadUrls['${url}_photo'] ?? '',
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.account_circle, size: 50.0),
                            ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            list[index].name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
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
