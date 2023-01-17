import 'package:flutter/material.dart';
import 'package:pullventure_flutter/auth/sign_in_startup2.dart';

class SignInStartUp extends StatefulWidget {
  const SignInStartUp({super.key});

  @override
  State<SignInStartUp> createState() => _SignInStartUpState();
}

class _SignInStartUpState extends State<SignInStartUp> {
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
            top: 20,
            left: 5,
            child: IconButton(
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
              const Text("Start-up account",
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
          padding: const EdgeInsets.only(top: 200.0, left: 40.0, right: 40.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 80,
            height: MediaQuery.of(context).size.height - 280,
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
                        "COMPANY NAME",
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
                const SizedBox(height: 30),
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
                      decoration: const InputDecoration(
                        hintText: "Enter your company email",
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
                        "PHONE NUMBER",
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
                        hintText: "Enter your company phone number",
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
                        "WEBSITE",
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
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, right: 20.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInStartUp2()));
                    }, child: const Text("Next >")),
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