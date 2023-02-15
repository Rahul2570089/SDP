import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pullventure_flutter/database/database_methods.dart';
import 'package:pullventure_flutter/model/startup_model.dart';
import 'package:readmore/readmore.dart';

class SelfProfileStartUp extends StatefulWidget {
  final String email;
  const SelfProfileStartUp({super.key, required this.email});

  @override
  State<SelfProfileStartUp> createState() => _SelfProfileStartUpState();
}

class _SelfProfileStartUpState extends State<SelfProfileStartUp> {
  DatabaseMethods dataBaseMethods = DatabaseMethods();
  Map<String, String> downloadUrls = {};
  StartUpModel searchListStartup = StartUpModel(
      name: "", email: "", headquarters: "", description: "", sector: "");
  bool isLoading = true;
  String url = "";
  PlatformFile? _image;

  TextEditingController aboutController = TextEditingController();
  TextEditingController sectorController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController headquartersController = TextEditingController();

  getUser() async {
    QuerySnapshot temp =
        await dataBaseMethods.getUserbyemail(widget.email, "startup");
    debugPrint(temp.docs.first['name']);

    searchListStartup = StartUpModel(
        name: temp.docs.first['name'],
        email: temp.docs.first['email'],
        headquarters: temp.docs.first['headquarters'],
        description: temp.docs.first['description'],
        sector: temp.docs.first['sector']);

    await dataBaseMethods.getAllLogos("startups").then((value) {
      setState(() {
        downloadUrls = value;
        url = downloadUrls["${widget.email}_photo"] ?? "";
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  showDialogToEdit(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Profile"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  index == 0
                      ? Column(
                          children: [
                            TextField(
                              controller: aboutController,
                              decoration: const InputDecoration(
                                hintText: "About",
                              ),
                            ),
                          ],
                        )
                      : index == 1
                          ? Column(
                              children: [
                                TextField(
                                  controller: sectorController,
                                  decoration: const InputDecoration(
                                    hintText: "Company Sector",
                                  ),
                                ),
                              ],
                            )
                          : index == 2
                              ? Column(
                                  children: [
                                    TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    TextField(
                                      controller: headquartersController,
                                      decoration: const InputDecoration(
                                        hintText: "Headquarters",
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Save"),
              ),
            ],
          );
        });
  }

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
      });

      if (!mounted) return;
      await dataBaseMethods.uploadLogo(context,
          image: _image, email: widget.email, type: "startups");
      await dataBaseMethods.getAllLogos("startups").then((value) {
        setState(() {
          downloadUrls = value;
          url = downloadUrls["${widget.email}_photo"] ?? "";
        });
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
              title: Text("${searchListStartup.name}'s Profile"),
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
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Stack(children: [
                                Image.network(
                                  url,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.account_circle,
                                          size: 150),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      pickImage(context);
                                    },
                                    icon: const Icon(Icons.edit,
                                        size: 25.0,
                                        color:
                                            Color.fromARGB(255, 144, 141, 141)),
                                  ),
                                ),
                              ]),
                        const SizedBox(height: 10.0),
                        Text(
                          searchListStartup.name!,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  const Text("About",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      )),
                                  const SizedBox(width: 10.0),
                                  IconButton(
                                    onPressed: () {
                                      showDialogToEdit(0);
                                    },
                                    icon: const Icon(Icons.edit,
                                        size: 20.0,
                                        color:
                                            Color.fromARGB(255, 144, 141, 141)),
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ReadMoreText(
                              searchListStartup.description!,
                              trimLines: 2,
                              colorClickableText: Colors.blue,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 117, 116, 116)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Company Sector",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ))),
                              const SizedBox(width: 10.0),
                              IconButton(
                                onPressed: () {
                                  showDialogToEdit(1);
                                },
                                icon: const Icon(Icons.edit,
                                    size: 20.0,
                                    color: Color.fromARGB(255, 144, 141, 141)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(searchListStartup.sector!,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 117, 116, 116)))),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Details",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ))),
                              const SizedBox(width: 10.0),
                              IconButton(
                                onPressed: () {
                                  showDialogToEdit(2);
                                },
                                icon: const Icon(Icons.edit,
                                    size: 20.0,
                                    color: Color.fromARGB(255, 144, 141, 141)),
                              ),
                            ],
                          ),
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
                                searchListStartup.email!,
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
                                searchListStartup.headquarters!,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 117, 116, 116)),
                              )),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
