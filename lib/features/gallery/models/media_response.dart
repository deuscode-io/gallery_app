import 'package:gallery_app/features/gallery/models/media_hits.dart';
import 'package:gallery_app/features/gallery/models/media_request.dart';

class MediaResponse {
  final MediaHits? hits;
  final MediaRequest request;
  final Exception? exception;

  MediaResponse({
    this.hits,
    required this.request,
    this.exception,
  });
}
