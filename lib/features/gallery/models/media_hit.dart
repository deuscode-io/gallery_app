import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_hit.freezed.dart';
part 'media_hit.g.dart';

@freezed
class MediaHit with _$MediaHit {
  const factory MediaHit({
    required int id,
    required String type,
    required String previewURL,
    required String largeImageURL,
    required int views,
    required int likes,
  }) = _MediaHit;

  factory MediaHit.fromJson(Map<String, dynamic> json) => _$MediaHitFromJson(json);
}
