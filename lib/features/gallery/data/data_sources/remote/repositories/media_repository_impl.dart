import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_app/core/network/media_api_service.dart';
import 'package:gallery_app/core/resources/data_state.dart';
import 'package:gallery_app/features/gallery/data/data_sources/remote/repositories/media_repository.dart';
import 'package:gallery_app/features/gallery/data/models/media_hit.dart';
import 'package:gallery_app/features/gallery/data/models/media_hits.dart';

class MediaRepositoryImpl implements MediaRepository {
  const MediaRepositoryImpl({required this.mediaApiService});

  final MediaApiService mediaApiService;

  @override
  Future<DataState<MediaHits>> call({
    required String query,
    required int page,
    required int perPage,
  }) async {
    try {
      final httpResponse = await mediaApiService.getMediaHits(
        query,
        page,
        perPage,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final jsonData = httpResponse.response.data as Map<String, dynamic>;

        final hits = await _parseHits(jsonData['hits'] as List<dynamic>);

        return DataSuccess(
          MediaHits(
            total: jsonData['total'],
            hits: hits,
          ),
        );
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<List<MediaHit>> _parseHits(List<dynamic> rawMedias) async {
    return compute(
      (list) => list.map((e) => MediaHit.fromJson(e)).toList(),
      rawMedias,
    );
  }
}
