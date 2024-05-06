import 'package:dio/dio.dart';
import 'package:gallery_app/DI/dependency_registrar.dart';
import 'package:gallery_app/core/network/media_api_service.dart';
import 'package:gallery_app/features/gallery/data/data_sources/remote/repositories/media_repository.dart';
import 'package:gallery_app/features/gallery/data/data_sources/remote/repositories/media_repository_impl.dart';
import 'package:gallery_app/secrets.dart';

const _timeout = Duration(seconds: 10);

void setupManualDI() {
  final dio = Dio(
    BaseOptions(
      sendTimeout: _timeout,
      connectTimeout: _timeout,
      baseUrl: baseUrl,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(onRequest: (options, handler) {
      options.queryParameters.addAll({'key': apiKey});
      return handler.next(options);
    }),
  );

  final mediaApiService = MediaApiService(dio);



  DependencyRegistrar.registerSingleton<Dio>(dio);
  DependencyRegistrar.registerSingleton<MediaApiService>(mediaApiService);
  DependencyRegistrar.registerSingleton<MediaRepository>(MediaRepositoryImpl(
    mediaApiService: mediaApiService,
  ));
}
