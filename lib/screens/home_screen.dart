import 'package:flutter/material.dart';
import 'package:flutter_news_app_ui/models/article_model.dart';
import 'package:flutter_news_app_ui/screens/screens.dart';
import 'package:flutter_news_app_ui/widgets/custom_tag.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/image_container.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/utilities.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> _fetchCryptoNews;

  @override
  void initState() {
    super.initState();
    _fetchCryptoNews = fetchCryptoNews();
  }

  Future<List<Article>> fetchCryptoNews() async {
    final response = await http.get(Uri.parse(
        "https://cryptopanic.com/api/v1/posts/?auth_token=177ab96ffe05ddf9d0ed21fe90630ed6fbe2ebaf&currencies=BTC,ETH,SOL,ADA,BNB,USDT,XRP,DOT,DOGE,LUNA,UNI,AVAX,THETA,MATIC,FIL,AAVE,ATOM,CAKE,TRX,XTZ,VET,FTT,ALGO,COMP,KSM,KLAY,CEL,GRT,REN,SRM,YFI,BCH,HBAR,ZEC,ONT,IOST,BTT,NEO,CHZ,BNT,RSR,CRO,QTUM,EGLD,SC,OKB,DASH,XMR,KSM"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;
      return results
          .map(
            (result) => Article(
              id: result['id'].toString(),
              title: result['title'],
              subtitle: result['domain'],
              body: result['title'],
              author: result['source']['title'],
              authorImageUrl:
                  "https://source.unsplash.com/300x300/?${"cryptocurrency " + result['title']}&client_id=your_access_key",
              category: result['currencies'][0]['title'],
              imageUrl:
                  "https://source.unsplash.com/600x400/?${"cryptocurrency " + result['title']}&client_id=your_access_key",
              views: 10,
              createdAt: DateTime.parse(result['published_at']),
              url: result['url'],
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to load crypto news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(index: 0),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<List<Article>>(
        future: _fetchCryptoNews,
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _NewsOfTheDay(article: snapshot.data![0]),
                _BreakingNews(articles: snapshot.data!.sublist(1)),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class _BreakingNews extends StatelessWidget {
  const _BreakingNews({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Breaking News',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text('More', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ArticleScreen.routeName,
                        arguments: articles[index],
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageContainer(
                          width: MediaQuery.of(context).size.width * 0.5,
                          imageUrl: articles[index].imageUrl,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                articles[index].title,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.5),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                  '${DateTime.now().difference(articles[index].createdAt).inHours} hours ago',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 5),
                              Text('by ${articles[index].author}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsOfTheDay extends StatelessWidget {
  const _NewsOfTheDay({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      imageUrl: article.imageUrl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTag(
            backgroundColor: Colors.grey.withAlpha(150),
            children: [
              Text(
                'News of the Day',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            article.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold, height: 1.25, color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              openUrl(context, article.url);
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Row(
              children: [
                Text(
                  'Learn More',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_right_alt,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
