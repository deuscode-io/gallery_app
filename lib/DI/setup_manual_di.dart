import 'package:dio/dio.dart';
import 'package:gallery_app/DI/dependency_registrar.dart';
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


  DependencyRegistrar.registerSingleton<Dio>(dio);
}
