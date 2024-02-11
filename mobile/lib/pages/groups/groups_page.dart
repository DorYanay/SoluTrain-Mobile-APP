import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

import '../../api.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  MyGroupsSchema? myGroups;

  void createGroupOnPressed() {
    Provider.of<AppModel>(context, listen: false).moveToCreateGroupPage();
  }

  // hooks
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
        body: const Text("Loading"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: createGroupOnPressed,
              icon: const Icon(Icons.add, size: 18),
              label: const Text("OUTLINED BUTTON"),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: myGroups!.coachGroups.length,
              itemBuilder: (context, index) {
                final group = myGroups!.coachGroups[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            )
          ],
        ),
      ),
    );
  }
}
