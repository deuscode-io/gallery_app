import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gallery_app/features/gallery/models/media_hit.dart';

part 'media_hits.freezed.dart';
part 'media_hits.g.dart';

@freezed
class MediaHits with _$MediaHits {
  const factory MediaHits({
    required int total,
    required List<MediaHit> hits,
  }) = _MediaHits;

  factory MediaHits.fromJson(Map<String, dynamic> json) =>
      _$MediaHitsFromJson(json);
}
