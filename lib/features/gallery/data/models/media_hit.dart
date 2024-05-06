import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_hit.freezed.dart';
part 'media_hit.g.dart';

abstract class MediaContent {}

class MediaLoading extends MediaContent {}

@freezed
class MediaHit extends MediaContent with _$MediaHit {
  const factory MediaHit({
    required int id,
    required String type,
    required String previewURL,
    required String largeImageURL,
    required int views,
    required int likes,
  }) = _MediaHit;

  factory MediaHit.fromJson(Map<String, dynamic> json) =>
      _$MediaHitFromJson(json);
}
