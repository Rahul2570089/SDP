class NewsModel {
  int? totalresults;
  String? url;
  String? urlimage;
  String? source;
  String? title;

  NewsModel({
    this.totalresults,
    this.url,
    this.urlimage,
    this.source,
    this.title,
  });

  factory NewsModel.fromJson(Map json) {
    return NewsModel(
      source: json['name'],
      url: json['url'],
      urlimage: json['urlToImage'],
      title: json['title'],
    );
  }
}


class NewsModel2 {
  int? totalresults;
  String? url;
  String? urlimage;
  String? source;
  String? title;

  NewsModel2({
    this.totalresults,
    this.url,
    this.urlimage,
    this.source,
    this.title,
  });

  factory NewsModel2.fromJson(Map json) {
    return NewsModel2(
      source: json['source_id'],
      url: json['link'],
      urlimage: json['image_url'],
      title: json['title'],
    );
  }
}