import 'package:gallery_app/features/gallery/data/models/media_hits.dart';

class MediaHitsFixture {
  static MediaHits obj() {
    return MediaHits.fromJson(MediaHitsFixture.json());
  }

  static Map<String, dynamic> json() {
    return {
      'total': 1,
      'hits': [
        {
          'id': 1,
          'type': 'photo',
          'previewURL': 'url',
          'largeImageURL': 'largeUrl',
          'views': 1,
          'likes': 1,
        }
      ]
    };
  }
}
