// This is example home page. delete and replace me.

import 'package:flutter/material.dart';

import '/api.dart';
import '/schemas.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _example() {
    String userId = 'eeb84d98-140b-45ac-9b46-fb5b8c800fcb';

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
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SoluTrain'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Example Request',
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: _example,
                  child: const Text('Example'),
                )
              ],
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
