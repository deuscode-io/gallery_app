import 'package:flutter/material.dart';
import 'package:gallery_app/DI/setup_automatic_di.dart';
import 'package:gallery_app/DI/setup_manual_di.dart';
import 'package:gallery_app/features/gallery/gallery_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupManualDI();
  setupAutomaticDI();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );

    // return MultiBlocProvider(
    //   providers: [],
    //   child: MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //       useMaterial3: true,
    //     ),
    //     home: const MyHomePage(title: 'Flutter Demo Home Page'),
    //   ),
    // );
  }
}
