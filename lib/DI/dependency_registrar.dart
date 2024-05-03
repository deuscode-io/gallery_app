import 'package:get_it/get_it.dart';

class DependencyRegistrar {
  const DependencyRegistrar();

  static void registerFactory<T extends Object>(FactoryFunc<T> factoryFunc) {
    GetIt.I.registerFactory<T>(factoryFunc);
  }

  static void registerSingleton<T extends Object>(T instance) {
    GetIt.I.registerSingleton<T>(instance);
  }

  static void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc,
  ) {
    GetIt.I.registerLazySingleton<T>(factoryFunc);
  }

  static void unregister<T extends Object>() {
    GetIt.I.unregister<T>();
  }
}
