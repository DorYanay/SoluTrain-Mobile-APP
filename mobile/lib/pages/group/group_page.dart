import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  final String groupId;

  const GroupPage(this.groupId, {super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  GroupFullSchema? fullGroup;

  void createMeetingOnPressed() {

  }

  @override
  void initState() {
    super.initState();

    API.post(context, '/group/get-as-coach').then((Response res) {
      if (res.hasError) {
        return;
      }

      setState(() {
        fullGroup = GroupFullSchema.fromJson(res.data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (fullGroup == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Groups'),
        ),
        body: const Text("Loading"),
      );
    }

    final areas = Provider.of<AppModel>(context).areas;

    final areaName = areas.where((element) => element.areaId == fullGroup!.group.areaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Name: ${fullGroup!.group.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Leader: ${fullGroup!.group.coachName}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Region: $areaName',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Meetings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: createMeetingOnPressed,
                        child: const Text('Create Meeting'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Meetings List
                    ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: fullGroup!.meets.length,
                    itemBuilder: (context, index) {
                      final meeting = fullGroup!.meets[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(''),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to meeting page
                            },
                            child: const Text('View'),
                          ),
                        ],
                      );
                    }),
                  ),
      ),
                  // Add more meetings as needed
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Participants',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Participants List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Participant 1'),
                      ElevatedButton(
                        onPressed: () {
                          // Remove participant
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Participant 2'),
                      ElevatedButton(
                        onPressed: () {
                          // Remove participant
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                  // Add more participants as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
