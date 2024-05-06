import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gallery_app/features/gallery/data/models/media_hit.dart';

part 'media_state.freezed.dart';

@freezed
class MediaState with _$MediaState {
  const factory MediaState({
    @Default(false) bool loading,
    @Default([]) List<MediaHit> media,
    DioException? exception,
  }) = _MediaState;


}
