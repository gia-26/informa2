import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:informa2/modules/news/components/news_card.dart';
import 'package:informa2/modules/news/models/news_model.dart';
import 'package:informa2/modules/news/provider/news_provider.dart';

class NewsCarousel extends StatelessWidget {
  const NewsCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsProvider = NewsProvider();

    return FutureBuilder<List<NewsModel>>(
      future: newsProvider.getNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final news = snapshot.data ?? [];

        return CarouselSlider.builder(
          itemCount: news.length,
          itemBuilder: (context, index, realIndex) {
            final newsItem = news[index];
            return NewsCard(news: newsItem, onTap: () {});
          },
          options: CarouselOptions(
            height: 350,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.98,
            enableInfiniteScroll: true,
          ),
        );
      },
    );
  }
}