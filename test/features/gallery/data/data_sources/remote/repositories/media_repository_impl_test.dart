import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/core/network/media_api_service.dart';
import 'package:gallery_app/core/resources/data_state.dart';
import 'package:gallery_app/features/gallery/data/data_sources/remote/repositories/media_repository_impl.dart';
import 'package:gallery_app/features/gallery/data/models/media_hits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retrofit/dio.dart';

import '../../../../../../test_utils/fixture/media_hits_fixture.dart';

const _query = 'query';
const _page = 1;
const _perPage = 50;
final _requestOptions = RequestOptions();

final _exception = DioException(
  requestOptions: _requestOptions,
  message: 'Some error',
  type: DioExceptionType.connectionTimeout,
);

class MockMediaApiService extends Mock implements MediaApiService {}

final MediaApiService _mediaApiService = MockMediaApiService();

void main() {
  group(
    'GIVEN $MediaRepositoryImpl',
    () {
      setUp(() => reset(_mediaApiService));

      test(
        'WHEN network call was successful '
        'THEN the media hits object gets returned',
        () async {
          when(_apiCall).thenAnswer(
            (_) async => HttpResponse(
              MediaHitsFixture.obj(),
              Response(
                data: MediaHitsFixture.json(),
                requestOptions: _requestOptions,
                statusCode: 200,
              ),
            ),
          );

          final result = await _getMediaHitsCall();

          expect(result is DataSuccess, true);
          expect(result.data!.total, MediaHitsFixture.obj().total);
          expect(result.data!.hits.length, MediaHitsFixture.obj().hits.length);
          expect(result.data!.hits, MediaHitsFixture.obj().hits);
        },
      );

      test(
        'WHEN network call was not successful '
        'THEN a dio exception with unknown type gets returned',
        () async {
          when(_apiCall).thenAnswer(
            (_) async => HttpResponse(
              MediaHitsFixture.obj(),
              Response(
                data: MediaHitsFixture.json(),
                requestOptions: _requestOptions,
                statusCode: 400,
              ),
            ),
          );

          final result = await _getMediaHitsCall();

          expect(result is DataFailed, true);
          expect(result.exception!.type, DioExceptionType.unknown);
        },
      );

      test(
        'WHEN network call was failed '
        'THEN dio exception gets returned',
        () async {
          when(_apiCall).thenThrow(_exception);

          final result = await _getMediaHitsCall();

          expect(result is DataFailed, true);
          expect(result.exception, _exception);
          expect(result.exception!.type, DioExceptionType.connectionTimeout);
        },
      );
    },
  );
}

Future<DataState<MediaHits>> _getMediaHitsCall() {
  return MediaRepositoryImpl(mediaApiService: _mediaApiService)(
    query: _query,
    page: _page,
    perPage: _perPage,
  );
}

Future<HttpResponse<MediaHits>> _apiCall() {
  return _mediaApiService.getMediaHits(_query, _page, _perPage);
}
