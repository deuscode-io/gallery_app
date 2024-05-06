import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      placeholder: (_, __) {
        return Container(
          color: Colors.black12,
          child: const Center(
            child: Icon(Icons.cloud_download_outlined),
          ),
        );
      },
      errorWidget: (_, __, ___) {
        return Container(
          color: Colors.black12,
          child: const Center(
            child: Icon(Icons.cloud_off),
          ),
        );
      },
      imageUrl: url,
    );
  }
}
