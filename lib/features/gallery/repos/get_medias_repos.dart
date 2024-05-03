import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_app/features/gallery/models/media_hit.dart';
import 'package:gallery_app/features/gallery/models/media_hits.dart';
import 'package:gallery_app/features/gallery/models/media_request.dart';
import 'package:gallery_app/features/gallery/models/media_response.dart';
import 'package:injectable/injectable.dart';

@singleton
class GetMediasRepo {
  const GetMediasRepo({required this.httpClient});

  final Dio httpClient;

  Future<MediaResponse> call(MediaRequest request) async {
    try {
      final response = await httpClient.get(
        '/',
        queryParameters: request.toJson(),
      );

      final jsonData = response.data as Map<String, dynamic>;

      final hits = await _parseHits(jsonData['hits'] as List<dynamic>);

      return MediaResponse(
        request: request,
        hits: MediaHits(total: jsonData['total'], hits: hits),
      );
    } on Exception catch (e) {
      return MediaResponse(request: request, exception: e);
    }
  }

  Future<List<MediaHit>> _parseHits(List<dynamic> rawMedias) async {
    return compute(
      (list) => list.map((e) => MediaHit.fromJson(e)).toList(),
      rawMedias,
    );
  }
}
