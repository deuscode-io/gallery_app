import 'package:bloc/bloc.dart';
import 'package:gallery_app/core/resources/data_state.dart';
import 'package:gallery_app/features/gallery/data/models/media_hit.dart';
import 'package:gallery_app/features/gallery/data/models/media_hits.dart';
import 'package:gallery_app/features/gallery/data/models/media_request.dart';
import 'package:gallery_app/features/gallery/domain/usecases/get_media_usecase.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_event.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final GetMediaUseCase _getMediaUseCase;

  final _requests = <MediaRequest>[];

  late String _query;
  late int _page;
  late int _perPage;
  int? _total;

  MediaBloc(this._getMediaUseCase) : super(const MediaState()) {
    on<OpenPage>((event, emit) async {
      _query = event.query;
      _page = 1;
      _perPage = event.perPage;
      await _composeRequest(emit);
    });

    on<ReachScrollEnd>((event, emit) async {
      if (_total != null && state.media.length < _total!) {
        await _composeRequest(emit);
      }
    });

    on<ReloadButtonPressed>((event, emit) async {
      _page = 1;
      _total = null;
      emit(state.copyWith(media: []));
      await _composeRequest(emit);
    });

    on<NewQuery>((event, emit) async {
      _query = event.text;
      _page = 1;
      _total = null;
      emit(state.copyWith(media: []));
      await _composeRequest(emit);
    });
  }

  Future<void> _composeRequest(Emitter<MediaState> emit) async {
    final request = MediaRequest(query: _query, page: _page, perPage: _perPage);

    // the query is already being executed
    // but it is not the last one to be executed
    if (_requests.contains(request)) {
      _requests.remove(request);
      _requests.add(request);
      return;
    }

    _requests.add(request);

    if (!state.loading || state.exception != null) {
      emit(state.copyWith(loading: true, exception: null));
    }

    final dataState = await _getMediaUseCase.call(params: request);

    // only data of the last executed request makes sense
    if (_requests.isEmpty || _requests.last != request) return;

    _requests.clear();

    _processData(emit, dataState);
  }

  void _processData(Emitter<MediaState> emit, DataState<MediaHits> dataState) {
    if (dataState is DataSuccess) {
      _page = ++_page;
      _total = dataState.data!.total;
      final media = <MediaHit>[
        ...state.media,
        ...dataState.data!.hits,
      ];
      emit(
        state.copyWith(
          loading: false,
          media: media,
        ),
      );
    }

    if (dataState is DataFailed) {
      emit(
        state.copyWith(
          loading: false,
          exception: dataState.exception,
        ),
      );
    }
  }
}
