import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/model/investor_model.dart';
import 'package:readmore/readmore.dart';

class SelfProfileInvestor extends StatefulWidget {
  final String email;

  const SelfProfileInvestor({
    super.key,
    required this.email,
  });

  @override
  State<SelfProfileInvestor> createState() => _SelfProfileInvestorState();
}

class _SelfProfileInvestorState extends State<SelfProfileInvestor> {
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  Map<String, String> downloadUrls = {};
  InvestorModel searchListInvestor = InvestorModel(
      name: "",
      email: "",
      mobileNumber: "",
      investmentSector: "",
      companyName: "",
      aboutCompany: "");
  bool isLoading = true;
  String url = "";

  getUser() async {
    QuerySnapshot temp =
        await dataBaseMethods.getUserbyemail(widget.email, "investor");
    debugPrint(temp.docs.first['name']);

    searchListInvestor = InvestorModel(
        name: temp.docs.first['name'],
        email: temp.docs.first['email'],
        mobileNumber: temp.docs.first['mobilenumber'],
        investmentSector: temp.docs.first['investmentsector'],
        companyName: temp.docs.first['companyname'],
        aboutCompany: temp.docs.first['aboutcompany']);

    await dataBaseMethods.getAllLogos("investors").then((value) {
      setState(() {
        downloadUrls = value;
        url = downloadUrls["${widget.email}_photo"] ?? "";
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: Text("${searchListInvestor.name}'s Profile"),
              backgroundColor: Colors.white,
              elevation: 0.3,
              centerTitle: true,
              titleTextStyle:
                  const TextStyle(color: Colors.black, fontSize: 20.0),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.network(
                      url,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.account_circle, size: 150),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    searchListInvestor.name!,
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
                        child: Text(searchListInvestor.investmentSector!,
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
                            url,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  searchListInvestor.companyName!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: ReadMoreText(
                                  "• ${searchListInvestor.aboutCompany!}",
                                  trimLines: 2,
                                  colorClickableText: Colors.blue,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 117, 116, 116)),
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
                          searchListInvestor.email!,
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
          );
  }
}
