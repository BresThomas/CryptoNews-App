import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/article_model.dart';

class ArticleService {
  static Future<List<Article>> fetchCryptoNews() async {
    final response = await http.get(Uri.parse(
        "https://cryptopanic.com/api/v1/posts/?auth_token=" +
            dotenv.env['API_KEY_CRYPTO_PANIC']! +
            "&currencies=BTC,ETH,SOL,ADA,BNB,USDT,XRP,DOT,DOGE,LUNA,UNI,AVAX,THETA,MATIC,FIL,AAVE,ATOM,CAKE,TRX,XTZ,VET,FTT,ALGO,COMP,KSM,KLAY,CEL,GRT,REN,SRM,YFI,BCH,HBAR,ZEC,ONT,IOST,BTT,NEO,CHZ,BNT,RSR,CRO,QTUM,EGLD,SC,OKB,DASH,XMR,KSM"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;
      return results
          .map((result) => Article(
                id: result['id'].toString(),
                title: result['title'],
                subtitle: result['domain'],
                body: result['title'],
                author: result['source']['title'],
                authorImageUrl:
                    "https://source.unsplash.com/300x300/?${"cryptocurrency " + result['title']}&client_id=" +
                        dotenv.env['API_KEY_UNSPLASH']!,
                category: result['currencies'][0]['title'],
                imageUrl:
                    "https://source.unsplash.com/600x400/?${"cryptocurrency " + result['title']}&client_id=" +
                        dotenv.env['API_KEY_UNSPLASH']!,
                views: 10,
                createdAt: DateTime.parse(result['published_at']),
                url: result['url'],
              ))
          .toList();
    } else {
      throw Exception('Failed to load crypto news');
    }
  }
}
