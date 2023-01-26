import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pullventure_client/pullventure_client.dart';
import 'package:pullventure_flutter/auth/authenticate.dart';
import 'package:pullventure_flutter/chatscreen/homescreen_chat.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/main.dart';

class SignInStartUp2 extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  const SignInStartUp2(
      {super.key,
      required this.email,
      required this.password,
      required this.name});

  @override
  State<SignInStartUp2> createState() => _SignInStartUp2State();
}

class _SignInStartUp2State extends State<SignInStartUp2> {
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
  PlatformFile? _image;
  Icon _icon = const Icon(Icons.upload_file_rounded);
  final formKey = GlobalKey<FormState>();
  TextEditingController companyHeadquarters = TextEditingController();
  TextEditingController basicDescription = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Future pickImage(BuildContext context) async {
    try {
      final image = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'svg'],
      );
      if (image == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
        return;
      }
      setState(() {
        _image = image.files.first;
        _icon = const Icon(Icons.check_circle_outline_rounded);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image selected'),
        ),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

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
              Text("Start-up account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 180.0, left: 18.0, right: 18.0, bottom: 30),
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
                          "COMPANY LOGO",
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
                        child: TextButton.icon(
                            onPressed: () {
                              pickImage(context);
                            },
                            style: const ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                            ),
                            icon: _icon,
                            label: const Text("Upload logo"))),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "COMPANY HEADQUARTERS",
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
                        controller: companyHeadquarters,
                        validator: (value) => value!.isEmpty
                            ? "Please enter your company headquarters"
                            : null,
                        decoration: const InputDecoration(
                          hintText: "Enter your company headquarters",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "BASIC DESCRIPTION",
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
                        controller: basicDescription,
                        validator: (value) => value!.isEmpty
                            ? "Please enter your company description"
                            : null,
                        decoration: const InputDecoration(
                          hintText: "Enter your company description",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "COMPANY SECTOR",
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
                              if (_image == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please upload your company logo")));
                                return;
                              }
                              if (selected == "Select sector") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please select your company sector")));
                                return;
                              }
                              AuthMethod.signupwithemailpassword(
                                      widget.email, widget.password, context)
                                  .then((value) async {
                                if (value != null) {
                                  databaseMethods.addStartup({
                                    "name": widget.name,
                                    "email": widget.email,
                                    "headquarters": companyHeadquarters.text,
                                    "description": basicDescription.text,
                                    "sector": selected,
                                  });
                                  final startup = StartUp(
                                    name: widget.name,
                                    email: widget.email,
                                    password: widget.password,
                                  );
                                  databaseMethods
                                      .uploadLogo(context,
                                          image: _image,
                                          email: widget.email,
                                          type: "startup")
                                      .then((value) async {
                                    await client.startUp.create(startup);
                                    if (mounted) return;
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChatHomeScreen(
                                                  type: "startup",
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
