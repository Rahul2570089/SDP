import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GovernmentSchemes extends StatefulWidget {
  const GovernmentSchemes({super.key});

  @override
  State<GovernmentSchemes> createState() => _GovernmentSchemesState();
}

class _GovernmentSchemesState extends State<GovernmentSchemes> {
  List<String> titles = [
    "Support for International Patent Protection in Electronics and & Information Technology (SIP-EIT)",
    "Stand-Up India for Financing SC/ST and/or Women Entrepreneurs",
    "Single Point Registration Scheme",
    "ExtraMural Research or Core Research Grant",
    "High Risk -High Reward Research",
    "IREDA NCEF Refinance Scheme",
    "Dairy Entrepreneurship Development Scheme",
    "Revamped Scheme of Fund for Regeneration of Traditional Industries (SFURTI)",
    "Assistance to Professional Bodies & Seminars/Symposia",
    "Software Technology Park Scheme"
  ];

  List<String> subtitles = [
    "Ministry Of Electronics & Information Technology",
    "Small Industries Development Bank of India (SIDBI)",
    "Ministry of Micro Small & Medium Enterprises",
    "Science and Engineering Research Board (SERB) under Ministry of Science & Technology",
    "Science and Engineering Research Board (SERB) under Department of Science & Technology",
    "Indian Renewable Energy Development Agency (IREDA)",
    "National Bank for Agriculture and Rural Development (NABARD)",
    "Khadi and Village Industries Commission under Ministry Of MSME",
    "Department Of Science & Technology",
    "Software Technology Parks of India Under Ministry of Electronics and Information Technology"
  ];

  List<String> images = [
    "assets/images/1.png",
    "assets/images/2.jpg",
    "assets/images/3.png",
    "assets/images/4.png",
    "assets/images/5.png",
    "assets/images/6.png",
    "assets/images/7.jpg",
    "assets/images/8.png",
    "assets/images/9.png",
    "assets/images/10.png"
  ];

  List<String> urls = [
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/international-patent-protection-sip-eit.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/stand-up-india.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/single-point-registration.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/extra-mural-research.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/high-risk-high-reward.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/national-clean-energy-fund-Refinance.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/dairy-entrepreneurship-development-scheme.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/revamped-scheme.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/assistance-to-professional-bodies.html",
    "https://www.startupindia.gov.in/content/sih/en/government-schemes/software-technology-park-scheme.html"
  ];

  Widget listview() {
    return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, position) {
          return Card(
            child: ListTile(
              title: Text(
                titles[position],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(subtitles[position]),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset(images[position], fit: BoxFit.cover)),
              ),
              onTap: () => {launchUrl(Uri.parse(urls[position]))},
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return listview();
  }
}
