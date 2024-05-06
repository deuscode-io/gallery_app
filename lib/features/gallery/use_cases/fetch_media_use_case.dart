import 'dart:async';

import 'package:gallery_app/features/gallery/cubits/media_loading_cubit.dart';
import 'package:gallery_app/features/gallery/models/media_hits.dart';
import 'package:gallery_app/features/gallery/models/media_request.dart';
import 'package:gallery_app/features/gallery/repos/get_medias_repos.dart';
import 'package:injectable/injectable.dart';

@singleton
class FetchMediaUseCase {
  final MediaLoadingCubit mediaLoadingCubit;
  final GetMediasRepo getMediasRepo;

  final _mediaRequests = <MediaRequest>[];

  FetchMediaUseCase({
    required this.mediaLoadingCubit,
    required this.getMediasRepo,
  });

  Future<(MediaHits?, Exception?)?> call({
    String query = '',
    int page = 1,
    int perPage = 50,
  }) async {
    final newRequest = MediaRequest(page, query, perPage);

    if (_mediaRequests.contains(newRequest)) {
      return null;
    }

    _updateLoadingCubit();

    _mediaRequests.add(newRequest);

    final mediaResponse = await getMediasRepo(newRequest);

    if (_mediaRequests.isEmpty || _mediaRequests.last != mediaResponse.request) {
      _mediaRequests.remove(mediaResponse.request);

      print('FetchMediaUseCase stop $query ${mediaResponse.request.query}');

      return null;
    }

    _updateLoadingCubit();

    _mediaRequests.clear();
    print('FetchMediaUseCase $query ${mediaResponse.request.query}');

    return (mediaResponse.hits, mediaResponse.exception);
  }

  void _updateLoadingCubit() {
    mediaLoadingCubit.state.when(
      initial: mediaLoadingCubit.setLoading,
      loading: mediaLoadingCubit.setInitial,
    );
  }
}
