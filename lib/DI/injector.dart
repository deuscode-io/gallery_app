import 'package:get_it/get_it.dart';

class Injector {
  T call<T extends Object>() => get<T>();

  static T get<T extends Object>() => GetIt.I.get<T>();
}
