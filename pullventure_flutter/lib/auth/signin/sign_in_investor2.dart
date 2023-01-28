import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pullventure_client/pullventure_client.dart';
import 'package:pullventure_flutter/auth/authenticate.dart';
import 'package:pullventure_flutter/chatscreen/homescreen_chat.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/main.dart';
import 'package:pullventure_flutter/model/constants.dart';

class SignInInvestor2 extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  const SignInInvestor2(
      {super.key,
      required this.email,
      required this.password,
      required this.name});

  @override
  State<SignInInvestor2> createState() => _SignInInvestor2State();
}

class _SignInInvestor2State extends State<SignInInvestor2> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  List<String> menuItem = [
    'Select sector',
    'Sector Agnostic',
    'Agriculture',
    'Advertising',
    'Aeronautics and space',
    'Airport operations',
    'Artificial Intelligence',
    'AR/VR (Augmented and virtual reality)',
    'Automation',
    'Architecture',
    'Art and Photography',
    'Automobile',
    'Biotechnology',
    'Blockchain',
    'Chemicals',
    'Construction',
    'Cloud computing',
    'Consumer goods',
    'Cryptocurrency',
    'Data analytics',
    'Defence',
    'Dating Matrimonal',
    'E-commerce',
    'Education',
    'Electronics',
    'Energy',
    'Entertainment',
    'Fashion',
    'Finance',
    'Food and beverage',
    'Gaming',
    'Government',
    'Healthcare',
    'Hospitality',
    'Human resources',
    'Insurance',
    'Information Technology',
    'Investment',
    'Logistics',
    'Manufacturing',
    'Marketing',
    'Media',
    'Medical devices',
    'Mobile',
    'Music',
    'Nanotechnology',
    'Natural resources',
    'Pharmaceuticals',
    'Real estate',
    'Retail',
    'Robotics',
    'Security',
    'Social media',
    'Sports',
    'Supply chain',
    'Telecommunications',
    'Textiles',
    'Transportation',
    'Travel and Tourism',
    'Venture capital',
    'Waste management',
    'Water'
  ];

  String selected = "Select sector";
  final formKey = GlobalKey<FormState>();
  static TextEditingController mobileNumber = TextEditingController();
  static TextEditingController companyName = TextEditingController();
  static TextEditingController aboutCompany = TextEditingController();
  static TextEditingController companyWebsite = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Image.asset(
          "./assets/images/background.png",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
            top: 30,
            left: 5,
            child: IconButton(
                iconSize: 35,
                splashColor: Colors.black,
                splashRadius: 5,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.chevron_left_sharp))),
        Positioned.fill(
          top: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Create new",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Text("Investor account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 180.0, left: 18, right: 18, bottom: 30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "MOBILE NUMBER",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: mobileNumber,
                        validator: (value) => value!.isEmpty
                            ? "Please enter your mobile number"
                            : null,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter your mobile number",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "COMPANY NAME (OPTIONAL)",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: companyName,
                        decoration: const InputDecoration(
                          hintText: "Enter your company name",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "ABOUT YOUR COMPANY",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: aboutCompany,
                        decoration: const InputDecoration(
                          hintText: "Enter one line about your company",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "COMPANY WEBSITE",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: companyWebsite,
                        decoration: const InputDecoration(
                          hintText: "Enter your company website",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "INVESTMENT SECTOR",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selected,
                          isExpanded: true,
                          items: menuItem
                              .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(e),
                                  )))
                              .toList(),
                          onChanged: (val) {
                            if (val!.isNotEmpty) {
                              setState(() {
                                selected = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              AuthMethod.signupwithemailpassword(
                                      widget.email, widget.password, context)
                                  .then((value) async {
                                if (value != null) {
                                  databaseMethods.addInvestor({
                                    "name": widget.name,
                                    "email": widget.email,
                                    "companyname": companyName.text,
                                    "aboutcompany": aboutCompany.text,
                                    "mobilenumber": mobileNumber.text,
                                    "investmentsector": selected,
                                  });
                                  final investor = Investor(
                                    name: widget.name,
                                    email: widget.email,
                                    password: widget.password,
                                  );
                                  await client.investor
                                      .create(investor)
                                      .then((value) {
                                    Constants.name = widget.name;
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatHomeScreen(
                                                  type: "investor",
                                                  name: widget.name,
                                                )),
                                        (route) => false);
                                  });
                                }
                              });
                            }
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size(250, 40),
                            ),
                            elevation: MaterialStateProperty.all<double>(0),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFfeb06a),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: const Text("Sign Up")),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
