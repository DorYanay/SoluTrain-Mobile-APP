import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:provider/provider.dart';

class MyGroupsPage extends StatefulWidget {
  const MyGroupsPage({super.key});

  @override
  State<MyGroupsPage> createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  void viewGroupOnPressed() {
    Provider.of<AppModel>(context, listen: false)
        .moveToViewGroupPage("", false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'my groups',
          style: TextStyle(
            color: Colors.grey,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: viewGroupOnPressed,
                  backgroundColor: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Team name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Coach name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: viewGroupOnPressed,
                  backgroundColor: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Team name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Coach name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: viewGroupOnPressed,
                  backgroundColor: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Team name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Coach name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: viewGroupOnPressed,
                  backgroundColor: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Team name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Coach name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: viewGroupOnPressed,
                  backgroundColor: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Team name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Coach name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: viewGroupOnPressed,
                  backgroundColor: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Team name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Coach name:',
                        style: TextStyle(
                          color: Colors.grey[850],
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
