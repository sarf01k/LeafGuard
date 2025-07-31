import 'package:flutter/material.dart';
import 'package:leafguard/utils/convert_date.dart';
import 'package:leafguard/widgets/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF21d660),
        elevation: 1,
        toolbarHeight: 80,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 16),
          child: SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2E2E2E), size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedImage(imageUrl: article['extracted_content']['top_image'], height: 250)
            ),
            SizedBox(height: 16),
            Text(
              article['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey.withOpacity(0.4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    convertDate(article['published date']),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7A7A7A)
                    ),
                  ),
                ),
                IconButton(
                  color: Color(0xFF7A7A7A),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Share.share('Check out this article: ${article['url']}');
                  },
                  icon: Icon(Icons.share_rounded)
                )
              ],
            ),
            Divider(color: Colors.grey.withOpacity(0.4)),
            SizedBox(height: 16),
            Text(
              article['description'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 8),
            Text(
              article['extracted_content']['text'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
