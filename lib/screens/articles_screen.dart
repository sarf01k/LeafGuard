// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:leafguard/services/articles_service.dart';
import 'package:leafguard/utils/convert_date.dart';
import 'package:leafguard/widgets/cached_network_image.dart';
import 'package:leafguard/widgets/shimmers.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late Future<List<dynamic>> _articles;
  int shimmerCount = 3;

  @override
  void initState() {
    super.initState();
    _articles = fetchArticlesOncePerDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Increase AppBar height
        child: AppBar(
          backgroundColor: const Color(0xFF21d660),
          title: null, // Disable default title
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft, // Bottom left alignment
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0), // Adjust spacing
              child: Text(
                'Recent Articles',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              FutureBuilder<List<dynamic>>(
                future: _articles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      // padding: EdgeInsets.all(16),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: shimmerCount,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            AppShimmers.imageShimmer(height: 200),
                            SizedBox(height: 8),
                            AppShimmers.textLineShimmer(width: double.infinity),
                            SizedBox(height: 4),
                            AppShimmers.textLineShimmer(width: double.infinity),
                            SizedBox(height: 30)
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.signal_wifi_off_rounded,
                              size: 80,
                              color: Colors.grey,
                            ),
                            Text(
                              'No Internet.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              'Check your network and try again.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _articles = fetchArticlesOncePerDay();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2E2E2E),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: TextStyle(
                                  color: Colors.white,fontWeight: FontWeight.w600
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    final articles = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedImage(
                                imageUrl: article['image'],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              article['title'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    convertDate(article['publishedAt']),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7A7A7A)
                                    ),
                                  ),
                                ),
                                IconButton(
                                  color: Color(0xFF7A7A7A),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  icon: Icon(Icons.share_rounded)
                                )
                              ],
                            ),
                            if (index != articles.length - 1) ...[
                              Divider(),
                              SizedBox(height: 10),
                            ]
                          ],
                        );
                      },
                    );
                  }
                },
              )
            ],
          )
        ),
      ),
    );
  }
}