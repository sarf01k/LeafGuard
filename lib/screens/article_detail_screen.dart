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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedImage(imageUrl: article['image'], height: 300),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16))
                ),
                child: Column(
                  children: [
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ghana’s agriculture sector is undergoing a quiet revolution, thanks to a surge in AgriTech startups using data, drones, and artificial intelligence to improve yields and reduce losses. In Accra, a startup called FarmNet provides real-time weather predictions and crop health diagnostics via mobile apps, allowing farmers to make informed decisions. Another company, AgroTrace, helps track produce from farm to market, improving transparency and reducing post-harvest losses. “Tech is changing how we farm,” said Selorm Ameyaw, a maize farmer in the Eastern Region who uses FarmNet. “Last year, I increased my yield by 40%”. According to the Ghana Startup Network, more than 120 AgriTech companies have launched in the past five years, with several receiving funding from international donors and accelerators. Experts believe Ghana could become a hub for agricultural innovation if these startups receive continued support and proper infrastructure.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'In a bold move to combat youth unemployment and ensure national food security, the Government of Ghana has officially launched the Youth in Agriculture Program (YAP). The initiative, unveiled at a ceremony in Tamale, seeks to attract young people into agriculture by offering them access to land, training, and modern farming equipment. Minister for Food and Agriculture, Dr. Yaw Frimpong, emphasized the critical role of youth in transforming Ghana’s agricultural sector. “Agriculture remains the backbone of our economy, yet it is aging. We must inject new energy into it,” he said. The program will begin with 5,000 selected participants across the Northern, Ashanti, and Eastern regions, each receiving starter kits including seeds, fertilizers, and access to irrigation facilities. Agricultural economist Dr. Leticia Owusu described the move as “a vital intervention” and added that with proper monitoring, the program could contribute significantly to both employment and food production in Ghana.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
