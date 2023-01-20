import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInInvestor2 extends StatefulWidget {
  const SignInInvestor2({super.key});

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
        Positioned(
          top: 70,
          left: MediaQuery.of(context).size.width / 2 - 105,
          child: Column(
            children: [
              const Text(
                "Create new",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const Text("Investor account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
              Row(
                children: [
                  const Text("Already Regsitered? "),
                  InkWell(
                      onTap: () {},
                      child: const Text(
                        "Log in here",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ))
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 180.0, left: 18, right: 18, bottom: 30),
          child: Container(
            // width: MediaQuery.of(context).size.width - 80,
            // height: MediaQuery.of(context).size.height - 240,
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
                const SizedBox(height: 10,),
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
                        onPressed: () {},
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            const Size(250, 40),
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFfeb06a),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
        )
      ]),
    );
  }
}
