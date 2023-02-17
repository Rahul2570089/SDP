import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
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
  String url2 = "";
  PlatformFile? _image;

  TextEditingController aboutController = TextEditingController();
  TextEditingController sectorController = TextEditingController();
  TextEditingController expTitle = TextEditingController();
  TextEditingController expCompany = TextEditingController();
  TextEditingController expDescription = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
        aboutCompany: temp.docs.first['aboutcompany'],
        about: temp.docs.first['about'],
        companytitle: temp.docs.first['companytitle']);

    await dataBaseMethods.getAllLogos("investors").then((value) {
      setState(() {
        downloadUrls = value;
        url = downloadUrls["${widget.email}_photo"] ?? "";
      });
    });
    await dataBaseMethods.getAllLogos("startups").then((value) {
      setState(() {
        downloadUrls = value;
        url2 = downloadUrls["${widget.email}_photo"] ?? "";
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
          return StatefulBuilder(builder: ((context, setState) {
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
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selected,
                                      isExpanded: true,
                                      items: menuItem
                                          .map((e) => DropdownMenuItem<String>(
                                              value: e,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
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
                                ],
                              )
                            : index == 2
                                ? Column(
                                    children: [
                                      TextField(
                                        controller: expTitle,
                                        decoration: const InputDecoration(
                                          hintText: "Title",
                                        ),
                                      ),
                                      TextField(
                                        controller: expCompany,
                                        decoration: const InputDecoration(
                                          hintText: "Company",
                                        ),
                                      ),
                                      TextField(
                                        controller: expDescription,
                                        decoration: const InputDecoration(
                                          hintText: "Company Description",
                                        ),
                                      ),
                                    ],
                                  )
                                : index == 3
                                    ? Column(
                                        children: [
                                          TextField(
                                            controller: emailController,
                                            decoration: const InputDecoration(
                                              hintText: "Email",
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
          }));
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
          image: _image, email: widget.email, type: "investors");
      await dataBaseMethods.getAllLogos("investors").then((value) {
        setState(() {
          downloadUrls = value;
          url = downloadUrls["${widget.email}_photo"] ?? "";
        });
      });
      if (mounted) return;
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
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Stack(children: [
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
                          Positioned(
                            bottom: 0,
                            right: -10,
                            child: IconButton(
                              onPressed: () {
                                pickImage(context);
                              },
                              icon: const Icon(Icons.edit,
                                  size: 25.0,
                                  color: Color.fromARGB(255, 144, 141, 141)),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 10.0),
                        Text(
                          searchListInvestor.name!,
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
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
                                  const SizedBox(width: 5.0),
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
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                searchListInvestor.about!,
                              )),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Investment Sector",
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
                              child: Text(searchListInvestor.investmentSector!,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                  ))),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Experience",
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
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  url2,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.account_circle,
                                          size: 50),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        searchListInvestor.companytitle!,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        searchListInvestor.companyName!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: ReadMoreText(
                                        "• ${searchListInvestor.aboutCompany!}",
                                        trimLines: 2,
                                        colorClickableText: Colors.blue,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: 'Show more',
                                        trimExpandedText: 'Show less',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 117, 116, 116)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Email",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ))),
                              const SizedBox(width: 10.0),
                              IconButton(
                                onPressed: () {
                                  showDialogToEdit(3);
                                },
                                icon: const Icon(Icons.edit,
                                    size: 20.0,
                                    color: Color.fromARGB(255, 144, 141, 141)),
                              ),
                            ],
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
