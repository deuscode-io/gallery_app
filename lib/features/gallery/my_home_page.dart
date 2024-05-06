import 'package:flutter/material.dart';
import 'package:gallery_app/DI/injector.dart';
import 'package:gallery_app/features/gallery/use_cases/fetch_media_use_case.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final FetchMediaUseCase _fetchMediaUseCase = Injector.get();

  @override
  void initState() {
    super.initState();
    doSMTH();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void doSMTH() async {
    _fetchMediaUseCase(query: 'L');
    await Future.delayed(const Duration(milliseconds: 20));
    _fetchMediaUseCase(query: 'La');
    await Future.delayed(const Duration(milliseconds: 20));
    _fetchMediaUseCase(query: 'Lab');
    await Future.delayed(const Duration(milliseconds: 20));
    _fetchMediaUseCase(query: 'Labr');
    await Future.delayed(const Duration(milliseconds: 20));
    _fetchMediaUseCase(query: 'Labra');
    final result = await _fetchMediaUseCase(query: 'Labrador');
    final b = result;
  }
}
