import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'media_loading_cubit.freezed.dart';
part 'media_loading_state.dart';

@singleton
class MediaLoadingCubit extends Cubit<MediaLoadingState> {
  MediaLoadingCubit() : super(const MediaLoadingState.initial());

  void setLoading() {
    state.whenOrNull(initial: () {
      emit(const MediaLoadingState.loading());
    });
  }

  void setInitial() => emit(const MediaLoadingState.initial());
}
