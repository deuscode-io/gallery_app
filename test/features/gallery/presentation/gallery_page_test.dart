import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/DI/dependency_registrar.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_bloc.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_event.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_state.dart';
import 'package:gallery_app/features/gallery/presentation/gallery_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_utils/fixture/media_hits_fixture.dart';

class MockMediaBloc extends MockBloc<MediaEvent, MediaState>
    implements MediaBloc {}

final MediaBloc _mediaBloc = MockMediaBloc();

void main() {
  setUpAll(() {
    DependencyRegistrar.registerSingleton(_mediaBloc);
  });

  setUp(() {
    reset(_mediaBloc);
  });

  group(
    'GIVEN $GalleryPage to test appearance',
    () {
      testWidgets(
        'WHEN there is an exception '
        'THEN the reload button gets displayed',
        (tester) async {
          await tester.pumpAndMock(
            MediaState(
              exception: DioException(
                requestOptions: RequestOptions(),
              ),
            ),
          );

          expect(find.byType(LoadedFailure), findsOneWidget);
        },
      );

      testWidgets(
        'WHEN the first page loads'
        'THEN the initial load is displayed',
        (tester) async {
          await tester.pumpAndMock(const MediaState(loading: true));

          expect(find.byType(InitialLoading), findsOneWidget);
        },
      );

      testWidgets(
        'WHEN nothing is loaded '
        'THEN an empty scene is displayed',
        (tester) async {
          await tester.pumpAndMock(const MediaState());

          expect(find.byType(LoadedEmpty), findsOneWidget);
        },
      );

      testWidgets(
        'WHEN any page (other than the first page) is loaded '
        'THEN there is a widget to show the loading process',
        (tester) async {
          await tester.pumpAndMock(
            MediaState(
              loading: true,
              media: MediaHitsFixture.obj().hits,
            ),
          );

          expect(find.byType(AppGridView), findsOneWidget);
        },
      );

      testWidgets(
        'WHEN any page is loaded (except the first page) '
        'THEN a widget appears showing the loading process',
        (tester) async {
          await tester.pumpAndMock(
            MediaState(
              loading: true,
              media: MediaHitsFixture.obj().hits,
            ),
          );

          expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        },
      );
    },
  );

  group(
    'GIVEN $GalleryPage to test bloc event emissions',
    () {
      testWidgets(
        'WHEN the page is pumped',
        (tester) async {
          await tester.pumpAndMock(const MediaState());

          verify(() => _mediaBloc.add(OpenPage(query: '', perPage: 30)));
        },
      );

      testWidgets(
        'WHEN the reload button is tapped',
        (tester) async {
          await tester.pumpAndMock(
            MediaState(
              exception: DioException(
                requestOptions: RequestOptions(),
              ),
            ),
          );

          await tester.tap(find.byType(ElevatedButton));

          verify(() => _mediaBloc.add(ReloadButtonPressed()));
        },
      );

      testWidgets(
        'WHEN the new search appeared',
        (tester) async {
          await tester.pumpAndMock(const MediaState());

          await tester.enterText(find.byType(TextField), 'query');
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          verify(() => _mediaBloc.add(NewQuery('query')));
        },
      );

      // testWidgets(
      //   'WHEN nothing is loaded '
      //   'THEN an empty scene is displayed',
      //   (tester) async {
      //     await tester.pumpAndMock(const MediaState());
      //
      //     expect(find.byType(LoadedEmpty), findsOneWidget);
      //   },
      // );
      //
      // testWidgets(
      //   'WHEN any page (other than the first page) is loaded '
      //   'THEN there is a widget to show the loading process',
      //   (tester) async {
      //     await tester.pumpAndMock(
      //       MediaState(
      //         loading: true,
      //         media: MediaHitsFixture.obj().hits,
      //       ),
      //     );
      //
      //     expect(find.byType(AppGridView), findsOneWidget);
      //   },
      // );
      //
      // testWidgets(
      //   'WHEN any page is loaded (except the first page) '
      //   'THEN a widget appears showing the loading process',
      //   (tester) async {
      //     await tester.pumpAndMock(
      //       MediaState(
      //         loading: true,
      //         media: MediaHitsFixture.obj().hits,
      //       ),
      //     );
      //
      //     expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      //   },
      // );
    },
  );
}

void _mockMediaState(MediaState state) {
  when(_mediaBloc.close).thenAnswer(Future.value);
  when(() => _mediaBloc.state).thenReturn(state);
  when(() => _mediaBloc.stream).thenAnswer((_) => Stream.value(state));
}

extension on WidgetTester {
  Future<void> appPumpWidget() async {
    return pumpWidget(
      const MaterialApp(
        home: Material(
          child: GalleryPage(),
        ),
      ),
    );
  }

  Future<void> pumpAndMock(MediaState state) async {
    _mockMediaState(state);
    await appPumpWidget();
  }
}
