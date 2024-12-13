import 'package:flutter/material.dart';
import 'package:newsproject/components/news_tile.dart';
import 'package:newsproject/services/news_service.dart';

class NewsListView extends StatelessWidget {
  const NewsListView({super.key});

  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 10,
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),

            child: const NewsTile(),
          );
        },
      ),
    );
  }
}
