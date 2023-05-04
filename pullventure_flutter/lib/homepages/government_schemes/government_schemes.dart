import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GovernmentSchemes extends StatefulWidget {
  const GovernmentSchemes({super.key});

  @override
  State<GovernmentSchemes> createState() => _GovernmentSchemesState();
}

class _GovernmentSchemesState extends State<GovernmentSchemes> {
  List<String> titles = [
    "Scheme to Support IPR Awareness Workshop/Seminars in E&IT sector",
    "Science and Technology (S&T) for Coir Institutions",
    "Technology Development Programme",
    "Drugs and Pharmaceutical Research",
    "Small Business Innovation Research Initiative (SBIRI)",
    "Financial Assistance to Professional Bodies & Seminars/ Symposia"
  ];

  List<String> subtitles = [
    "Ministry Of Electronics & Information Technology",
    "Ministry of Micro, Small and Medium Enterprises",
    "Ministry of Science & Technology, Department of Science and Technology",
    "Department Of Science & Technology",
    "Ministry of Science & Technology, Biotechnology Industry Research Assistance Council (BIRAC)",
    "Ministry of Science & Technology, NSERB INDIA"
  ];

  List<String> images = [
    "assets/images/1.png",
    "assets/images/3.png",
    "assets/images/4.png",
    "assets/images/4.png",
    "assets/images/7.jpg",
    "assets/images/4.png",
  ];

  List<String> urls = [
    "https://www.indiascienceandtechnology.gov.in/funding-opportunities/startups/scheme-support-ipr-awareness-seminarsworkshops-eit-sector",
    "https://msme.gov.in/sites/default/files/Revised_Operation_Guidelines_of_CVY.pdf",
    "https://dst.gov.in/technology-development-program-tdp",
    "https://dst.gov.in/drugs-pharmaceutical-research",
    "https://birac.nic.in/desc_new.php?id=217",
    "https://serbonline.in/SERB/seminar_symposia"
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
