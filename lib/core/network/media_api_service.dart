import 'package:dio/dio.dart';
import 'package:gallery_app/features/gallery/data/models/media_hits.dart';
import 'package:gallery_app/secrets.dart';
import 'package:retrofit/retrofit.dart';

part 'media_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class MediaApiService {
  factory MediaApiService(Dio dio, {String baseUrl}) = _MediaApiService;

  @GET('/')
  Future<HttpResponse<MediaHits>> getMediaHits(
    @Query("q") String query,
    @Query("page") int page,
    @Query("per_page") int perPage,
  );
}
