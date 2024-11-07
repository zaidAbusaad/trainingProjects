import 'package:dio/dio.dart';
import 'package:newsproject/models/article_model.dart';

class NewsService {
  final Dio dio;

  NewsService(this.dio);

  getNews() async {
    var response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=93aa88169a274d16a343edc50e6685c1');
    Map<String, dynamic> jsonData = response.data;
    List<dynamic> articles = jsonData['articles'];

    List<ArticleModel> articlesList = [];

    for (var article in articles) {
      ArticleModel articleModel = ArticleModel(
        image: article['urlToImage'],
        subTitle: article['description'],
        title: article['title'],
      );
      articlesList.add(articleModel);
    }
  }
}
