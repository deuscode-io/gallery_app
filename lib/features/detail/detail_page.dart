import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String imageUrl;

  const DetailPage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageUrl,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
      ),
    );
  }
}
