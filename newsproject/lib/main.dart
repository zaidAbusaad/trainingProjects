import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newsproject/services/news_service.dart';
import 'screens/home_page.dart';

void main() {
NewsService(Dio()).getNews();
  runApp(NewsApp());
}


class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
