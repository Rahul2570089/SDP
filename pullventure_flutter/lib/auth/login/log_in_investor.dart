import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pullventure_client/pullventure_client.dart';
import 'package:pullventure_flutter/auth/authenticate.dart';
import 'package:pullventure_flutter/auth/signin/sign_in_investor.dart';
import 'package:pullventure_flutter/chatscreen/homescreen_chat.dart';
import 'package:pullventure_flutter/main.dart';
import 'package:pullventure_flutter/model/Constants.dart';

class LogInInvestor extends StatefulWidget {
  const LogInInvestor({super.key});

  @override
  State<LogInInvestor> createState() => _LogInInvestorState();
}

class _LogInInvestorState extends State<LogInInvestor> {
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

  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
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
                top: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Login to your",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    const Text("Investor account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInInvestor()));
                            },
                            child: const Text(
                              "Sign up here",
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
                padding: const EdgeInsets.only(
                    top: 250.0, left: 18.0, right: 18.0, bottom: 200),
                child: Container(
                  alignment: Alignment.center,
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
                                "EMAIL",
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
                              controller: email,
                              validator: (value) => value!.isEmpty
                                  ? "Please enter your email"
                                  : null,
                              decoration: const InputDecoration(
                                hintText: "Enter your email",
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
                                "PASSWORD",
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
                              controller: password,
                              obscureText: true,
                              validator: (value) => value!.isEmpty
                                  ? "Please enter your password"
                                  : null,
                              decoration: const InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    AuthMethod.signinwithemailpassword(
                                        email.text, password.text, context);
                                    List<Investor> list =
                                        await client.investor.readAll();
                                    for (var i in list) {
                                      if (i.email == email.text &&
                                          i.password == password.text) {
                                        Constants.name = i.name;
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Login Successful"),
                                          duration: Duration(seconds: 1),
                                        ));
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatHomeScreen(
                                                      type: "investor",
                                                      name: i.name,
                                                    )),
                                            (route) => false);
                                        return;
                                      } else if (i.email == email.text &&
                                          i.password != password.text) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please enter correct credentials")));
                                      }
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Account does not exist'),
                                      ),
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(250, 40),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color(0xFFfeb06a),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: const Text("Log in")),
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
