import 'package:gallery_app/core/resources/data_state.dart';
import 'package:gallery_app/features/gallery/data/models/media_hits.dart';

abstract class MediaRepository {
  Future<DataState<MediaHits>> call({
    required String query,
    required int page,
    required int perPage,
  });
}
