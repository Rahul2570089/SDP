import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pullventure_flutter/model/news_model.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  Map? mapresponse;
  List<NewsModel> list = [];

  Future<List<NewsModel>> apicall() async {
    Response response, response2;
    response = await get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=d8344f148be2417e837ab60a95d03be9"));
    response2 = await get(Uri.parse(
        "https://newsdata.io/api/1/news?apikey=pub_1543191e87867147491165c757ef41e6e7741&q=Startups&country=in&language=en,hi&category=business,politics,top,world"));
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          mapresponse = json.decode(response.body);
          var resp = mapresponse!['articles'] as List;
          list = resp.map((json) => NewsModel.fromJson(json)).toList();
        });
      }
    }
    if (response2.statusCode == 200) {
      if (mounted) {
        setState(() {
          mapresponse = json.decode(response2.body);
          var resp = mapresponse!['results'] as List;
          list += resp
              .map((json) => NewsModel(
                    source: json['source_id'],
                    url: json['link'],
                    urlimage: json['image_url'],
                    title: json['title'],
                  ))
              .toList();
        });
      }
    }
    return list;
  }

  Widget listview(List<NewsModel> news) {
    return ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, position) {
          return Card(
            child: ListTile(
              title: Text(
                news[position].title != null
                    ? '${news[position].title}'
                    : "No title available",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: news[position].urlimage == null
                      ? Image.asset(
                          "./assets/images/unavailable.png",
                          fit: BoxFit.contain,
                        )
                      : Image.network(
                          '${news[position].urlimage}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "./assets/images/unavailable.png",
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                ),
              ),
              onTap: () => {launchUrl(Uri.parse(news[position].url!))},
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apicall(),
        builder: (context, snapshot) {
          return snapshot.data != null
              ? listview(snapshot.data as List<NewsModel>)
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
        });
  }
}
