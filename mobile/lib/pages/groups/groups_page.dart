import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:provider/provider.dart';

import 'package:mobile/schemas.dart';
import 'package:mobile/api.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  MyGroupsSchema? myGroups;

  void leadingPageOnPressed() {
    Provider.of<AppModel>(context, listen: false)
        .moveToProfilePage();
  }

  void createGroupOnPressed() {
    Provider.of<AppModel>(context, listen: false).moveToCreateGroupPage();
  }

  void viewGroupOnTap(GroupSchema group) {
    Provider.of<AppModel>(context, listen: false)
        .moveToGroupPage(group.groupId);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: leadingPageOnPressed,
          ),
          title: const Text('Groups'),
        ),
        body: const Text("Loading"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: leadingPageOnPressed,
        ),
        title: const Text('Groups'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: createGroupOnPressed,
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Create Group"),
            ),
            const SizedBox(
              height: 10.0,
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
                      onTap: () => viewGroupOnTap(group),
                      title: Text(
                        group.name,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
