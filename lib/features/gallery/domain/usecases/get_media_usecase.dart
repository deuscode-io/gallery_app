import 'package:gallery_app/core/resources/data_state.dart';
import 'package:gallery_app/core/usecase/usecase.dart';
import 'package:gallery_app/features/gallery/data/data_sources/remote/repositories/media_repository.dart';
import 'package:gallery_app/features/gallery/data/models/media_hits.dart';
import 'package:gallery_app/features/gallery/data/models/media_request.dart';
import 'package:injectable/injectable.dart';

@singleton
class GetMediaUseCase implements UseCase<DataState<MediaHits>, MediaRequest> {
  final MediaRepository mediaRepository;

  GetMediaUseCase(this.mediaRepository);

  @override
  Future<DataState<MediaHits>> call({MediaRequest? params}) async {
    final result = await mediaRepository.call(
      query: params?.query ?? '',
      page: params?.page ?? 1,
      perPage: params?.perPage ?? 50,
    );

    return result;
  }
}
