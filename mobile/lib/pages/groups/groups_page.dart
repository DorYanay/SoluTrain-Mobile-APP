import 'package:flutter/material.dart';
import 'package:mobile/schemas.dart';

import '../../api.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  MyGroupsSchema? myGroups;

  // hooks
  @override
  void initState() {
    super.initState();

    API.post(context, '/my-groups/get').then((Response res) {
      if (res.hasError) {
        // TODO: handle error
        return;
      }

      setState(() {
        myGroups = MyGroupsSchema.fromJson(res.data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (myGroups == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Groups'),
        ),
        body: Text("Loading"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: ListView.builder(
        itemCount: myGroups!.coachGroups.length,
        itemBuilder: (context, index) {
          final group = myGroups!.coachGroups[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ListTile(
                title: Text(
                  group.name,
                ),
              ),
            ),
          );
        },
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
