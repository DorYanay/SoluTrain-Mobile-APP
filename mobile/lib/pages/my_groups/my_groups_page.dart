import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

import 'package:mobile/api.dart';

class MyGroupsPage extends StatefulWidget {
  const MyGroupsPage({super.key});

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
        body: const Text("Loading"),
      );
    }

    int rowsCount = myGroups!.inGroups.length ~/ 2;
    int lastRowGroupCount = 2;
    if (rowsCount * 2 < myGroups!.inGroups.length) {
      lastRowGroupCount = (myGroups!.inGroups.length - rowsCount * 2);
      rowsCount++;
    }


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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: rowsCount,
        itemBuilder: (context, rowIndex) {
          final rowCount = rowIndex == rowsCount - 1 ? lastRowGroupCount : 2;
          final rowGroups = myGroups!.inGroups.getRange(rowIndex * 2, rowIndex * 2 + rowCount).toList();
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (GroupInfoSchema group in rowGroups)
                      SizedBox(
                        width: 110,
                        height: 100,
                        child: FloatingActionButton(
                          onPressed: () { viewGroupOnPressed(group); },
                          backgroundColor: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                group.name,
                                style: TextStyle(
                                  color: Colors.grey[850],
                                  letterSpacing: 2.0,
                                ),
                              ),
                              Text(
                                group.coachName,
                                style: TextStyle(
                                  color: Colors.grey[850],
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ]
                ),
              ]
            );
        }),
      );
  }
}
