import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> fetchArticlesOncePerDay() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().split('T')[0];
  final lastFetchedDate = prefs.getString('lastFetchedDate');

  if (lastFetchedDate == today) {
    final cached = prefs.getString('cachedArticles');
    if (cached != null) return jsonDecode(cached);
    return [];
  }

  final url = dotenv.env['ARTICLES_API'];
  final res = await http.get(Uri.parse(url!));

  if (res.statusCode == 200) {
    final json = jsonDecode(res.body);
    final articles = json['articles'] ?? [];

    await prefs.setString('lastFetchedDate', today);
    await prefs.setString('cachedArticles', jsonEncode(articles));

    return articles;
  } else {
    throw Exception("Failed to fetch articles");
  }
}