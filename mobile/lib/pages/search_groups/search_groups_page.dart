import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class SearchGroupsPage extends StatefulWidget {
  final AreaSchema area;

  const SearchGroupsPage(this.area, {Key? key}) : super(key: key);

  @override
  State<SearchGroupsPage> createState() => _SearchGroupsPageState();
}

class _SearchGroupsPageState extends State<SearchGroupsPage> {
  AreaSchema? selectedOption;
  List<GroupSchema>? groups;

  void leadingPageOnPressed() {
    Provider.of<AppModel>(context, listen: false)
        .moveToSelectAreaPage();
  }

  void viewGroupOnPressed(GroupSchema group) {
    Provider.of<AppModel>(context, listen: false)
        .moveToViewGroupPage(group.groupId, true);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: leadingPageOnPressed,
          ),
          title: const Text('Search Groups'),
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
        title: Row(
          children: [
            const Icon(Icons.group), // Group icon
            const SizedBox(width: 10), // Add some space between icon and title
            Text(
              'Search Groups - ${widget.area.name}',
              style: const TextStyle(fontSize: 24), // Big font size
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
                onPressed: () {
                  viewGroupOnPressed(group);
                },
                child: const Text('Info'),
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
