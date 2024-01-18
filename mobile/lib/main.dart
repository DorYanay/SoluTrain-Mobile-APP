import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'api.dart';
import 'schemas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String title = 'DEMO';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _example(String userId) {
    debugPrint('Send request');

    API.post('/users/get', params: {
      'user_id': userId,
    }).then((res) {
      debugPrint('Return: ${res.statusCode}: ${res.errorMessage}');

      if (res.hasError) {
        return;
      }

      User user = User.fromJson(res.data);
      debugPrint('User: ${user.name} -> ${user.email}');
      return;
    });
  }

  void _incrementCounter() {

    // For check sending request to db
    // _example('eeb84d98-140b-45ac-9b46-fb5b8c800fcb');

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
}

