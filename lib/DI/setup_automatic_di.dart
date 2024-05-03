import 'package:gallery_app/DI/setup_automatic_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final _getIt = GetIt.instance;

@InjectableInit()
void setupAutomaticDI() => _getIt.init();
