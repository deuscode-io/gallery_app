import 'package:flutter/material.dart';
import 'package:gallery_app/features/gallery/presentation/widgets/app_network_image.dart';

class DetailPage extends StatelessWidget {
  final String imageUrl;

  const DetailPage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
        tag: imageUrl,
        child: Center(
          child: AppNetworkImage(url: imageUrl),
        ),
      ),
    );
  }
}
