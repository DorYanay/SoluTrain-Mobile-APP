import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

import 'package:mobile/api.dart';

class MyGroupsPage extends StatefulWidget {
  const MyGroupsPage({Key? key}) : super(key: key);

  @override
  State<MyGroupsPage> createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  MyGroupsSchema? myGroups;

  void viewGroupOnPressed(GroupInfoSchema group) {
    Provider.of<AppModel>(context, listen: false)
        .moveToViewGroupPage(group.groupId, false);
  }

  @override
  void initState() {
    super.initState();

    API.post(context, '/my-groups/get').then((Response res) {
      if (res.hasError) {
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
          title: const Text('Groups'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'My Groups',
          style: TextStyle(
            color: Colors.grey,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: myGroups!.inGroups.length,
        itemBuilder: (context, index) {
          final group = myGroups!.inGroups[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                onTap: () {
                  viewGroupOnPressed(group);
                },
                title: Text(
                  group.name,
                  style: TextStyle(
                    color: Colors.grey[850],
                    letterSpacing: 2.0,
                  ),
                ),
                subtitle: Text(
                  'Coach: ${group.coachName}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
