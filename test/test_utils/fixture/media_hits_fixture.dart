import 'package:gallery_app/features/gallery/data/models/media_hits.dart';

class MediaHitsFixture {
  static MediaHits obj({int id = 1}) {
    return MediaHits.fromJson(MediaHitsFixture.json(id: id));
  }

  static Map<String, dynamic> json({int id = 1}) {
    return {
      'total': id,
      'hits': [
        {
          'id': id,
          'type': 'photo',
          'previewURL': 'url',
          'largeImageURL': 'largeUrl',
          'views': id,
          'likes': id,
        }
      ]
    };
  }
}
