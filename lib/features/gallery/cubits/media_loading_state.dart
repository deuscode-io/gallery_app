part of 'media_loading_cubit.dart';

@freezed
class MediaLoadingState with _$MediaLoadingState {
  const factory MediaLoadingState.initial() = _Initial;

  const factory MediaLoadingState.loading() = _Loading;
}
