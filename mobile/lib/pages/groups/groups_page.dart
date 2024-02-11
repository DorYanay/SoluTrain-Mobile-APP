import 'package:flutter/material.dart';
import 'package:mobile/schemas.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'Groups',
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
              Container(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
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
              Container(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
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
              Container(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
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
              Container(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
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
              Container(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
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
              Container(
                width: 110,
                height: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
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

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'My group',
          style: TextStyle(
            color: Colors.grey,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 25.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.groups_rounded,
                  size: 200.0,
                  color: Colors.black12,
                ),
              ),
              Text(
                'Name of the team:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Name of the coach:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Number of members:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Time of the meeting:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Area:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'City:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Address:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
      ),
    );
  }
}
