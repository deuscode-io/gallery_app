import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/DI/dependency_registrar.dart';
import 'package:gallery_app/core/resources/data_state.dart';
import 'package:gallery_app/features/gallery/data/models/media_hits.dart';
import 'package:gallery_app/features/gallery/data/models/media_request.dart';
import 'package:gallery_app/features/gallery/domain/usecases/get_media_usecase.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_bloc.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_event.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_utils/fixture/media_hits_fixture.dart';

const _query1 = '';
const _request1 = MediaRequest(query: _query1, page: 1, perPage: 30);
final _response1 = DataSuccess<MediaHits>(MediaHitsFixture.obj());

const _query2 = 'some';
const _request2 = MediaRequest(query: _query2, page: 1, perPage: 30);
final _response2 = DataSuccess<MediaHits>(MediaHitsFixture.obj(id: 2));

final _exp =
    DioException(requestOptions: RequestOptions(), message: 'exception');
final _expResponse = DataFailed<MediaHits>(_exp);

class MockGetMediaUseCase extends Mock implements GetMediaUseCase {}

final GetMediaUseCase _getMediaUseCase = MockGetMediaUseCase();

void main() {
  setUpAll(() {
    DependencyRegistrar.registerSingleton(_getMediaUseCase);
  });

  setUp(() {
    reset(_getMediaUseCase);
  });

  group(
    'GIVEN $MediaBloc to test the sequence of events',
    () {
      blocTest<MediaBloc, MediaState>(
        'WHEN the first request becomes the last one',
        setUp: _whenSequence,
        build: () => MediaBloc(_getMediaUseCase),
        act: (bloc) async {
          bloc.add(OpenPage(query: _query1, perPage: 30));
          bloc.add(NewQuery(_query2));
          bloc.add(NewQuery(_query1));
        },
        wait: const Duration(seconds: 2),
        expect: () => <MediaState>[
          const MediaState(loading: true),
          MediaState(loading: false, media: MediaHitsFixture.obj().hits),
        ],
      );

      blocTest<MediaBloc, MediaState>(
        'WHEN the first request gets outdated',
        setUp: _whenSequence,
        build: () => MediaBloc(_getMediaUseCase),
        act: (bloc) async {
          bloc.add(OpenPage(query: _query1, perPage: 30));
          bloc.add(NewQuery(_query2));
        },
        wait: const Duration(seconds: 2),
        expect: () => <MediaState>[
          const MediaState(loading: true),
          MediaState(loading: false, media: MediaHitsFixture.obj(id: 2).hits),
        ],
      );
    },
  );

  group(
    'GIVEN $MediaBloc to test dio exception firing',
    () {
      blocTest<MediaBloc, MediaState>(
        'WHEN the request gets failed',
        setUp: _whenDioException,
        build: () => MediaBloc(_getMediaUseCase),
        act: (bloc) async {
          bloc.add(OpenPage(query: _query1, perPage: 30));
        },
        wait: const Duration(seconds: 2),
        expect: () => <MediaState>[
          const MediaState(loading: true),
          MediaState(loading: false, exception: _exp),
        ],
      );
    },
  );
}

void _whenSequence() {
  when(() => _getMediaUseCase(params: _request1)).thenAnswer((_) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _response1;
  });
  when(() => _getMediaUseCase(params: _request2)).thenAnswer((_) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _response2;
  });
}

void _whenDioException() {
  when(() => _getMediaUseCase(params: _request1)).thenAnswer((_) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _expResponse;
  });
}
