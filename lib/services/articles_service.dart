import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> fetchArticlesOncePerDay() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().split('T')[0];
  final lastFetchedDate = prefs.getString('lastFetchedDate');

  final isSameDay = lastFetchedDate == today;

  if (isSameDay) {
    final cached = prefs.getString('cachedArticles');
    if (cached != null) return jsonDecode(cached);
    return [];
  }

  final url = dotenv.env['ARTICLES_API_1'];
  if (url == null || url.isEmpty) {
    throw Exception("Missing ARTICLES_API_1 in .env file");
  }

  final uri = Uri.parse(url);

  final res = await http.get(uri);

  if (res.statusCode == 200) {
    final json = jsonDecode(res.body);
    final articles = json['articles'] ?? [];

    await prefs.setString('lastFetchedDate', today);
    await prefs.setString('cachedArticles', jsonEncode(articles));

    return articles;
  } else {
    throw Exception("Failed to fetch articles: ${res.statusCode}");
  }
}
