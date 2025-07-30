// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;

  final customCacheManager = CacheManager(
    Config(
      'leafguardCacheKey',
      stalePeriod: const Duration(hours: 6),
      maxNrOfCacheObjects: 600,
    ),
  );

  CachedImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheManager: customCacheManager,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildImageShimmer(),
      errorWidget: (context, error, stackTrace) =>
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          child: Icon(
            Icons.image_not_supported,
            color: const Color(0xFF666666).withOpacity(0.3),
          )
        ),
    );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Color(0xFFE0E0E0),
      highlightColor: Color(0xFFF5F5F5),
      period: Durations.medium3,
      child: Container(
        height: 120,
        color: Color(0xFFE0E0E0)
      ),
    );
  }
}
