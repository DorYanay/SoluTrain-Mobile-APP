import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class SearchGroupPage extends StatefulWidget {
  final AreaSchema area;

  const SearchGroupPage(this.area, {Key? key}) : super(key: key);

  @override
  State<SearchGroupPage> createState() => _SearchGroupPageState();
}

class _SearchGroupPageState extends State<SearchGroupPage> {
  AreaSchema? selectedOption; // Make the selectedOption variable nullable
  List<GroupSchema>? groups;

  void viewGroupOnPressed(GroupSchema group) {
    Provider.of<AppModel>(context, listen: false).moveToMyGroupPage(group.groupId);
  }

  @override
  void initState() {
    super.initState();

    API.post(context, '/search-groups/get-groups-by-area', params: {
      'area_id': widget.area.areaId,
    }).then((Response res) {
      if (res.hasError) {
        return;
      }

      setState(() {
        groups = (res.data as List<dynamic>)
            .map((group) => GroupSchema.fromJson(group))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (groups == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Groups'),
        ),
        body: const Text("Loading"),
      );
    }

    print(groups);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.group), // Group icon
            SizedBox(width: 10), // Add some space between icon and title
            Text(
              'Search Group - ${widget.area.name}',
              style: TextStyle(fontSize: 24), // Big font size
            ),
          ],
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: groups!.length,
        itemBuilder: (context, index) {
          final group = groups![index];
          return ListTile(
            title: Text(group.name),
            subtitle: Text(group.coachName),
            trailing: ElevatedButton(
              onPressed: () { viewGroupOnPressed(group); },
              child: Text('Info'),
            ),
          );
        }),
    );
  }
}

class GroupInfoPage extends StatelessWidget {
  const GroupInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Info'),
      ),
      body: const Center(
        child: Text('Group info will be shown here'),
      ),
    );
  }
}
