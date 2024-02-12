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

  String getMeetingTitle(MeetSchema meeting) {
    final month = meeting.meetDate.month.toString().padLeft(2, '0');
    final day = meeting.meetDate.day.toString().padLeft(2, '0');

    return '$month/$day';
  }

  void createMeetingOnPressed() {
    Provider.of<AppModel>(context, listen: false)
        .moveToCreateMeetingPage(fullGroup!.group.groupId);
  }

  void viewMeetingOnPressed(MeetSchema meeting) {}

  void removeParticipantOnPressed(UserBaseSchema user) {}

  @override
  void initState() {
    super.initState();

    API.post(context, '/group/get-as-coach', params: {
      'group_id': widget.groupId,
    }).then((Response res) {
      print(res.errorBody);
      print(res.errorMessage);
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

    final area = areas
        .where((element) => element.areaId == fullGroup!.group.areaId)
        .toList();

    final areaName = area[0].name;

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
                          Text(getMeetingTitle(meeting)),
                          ElevatedButton(
                            onPressed: () {
                              viewMeetingOnPressed(meeting);
                            },
                            child: const Text('View'),
                          ),
                        ],
                      );
                    },
                  ),
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
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: fullGroup!.members.length,
                    itemBuilder: (context, index) {
                      final participant = fullGroup!.members[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(participant.name),
                          ElevatedButton(
                            onPressed: () {
                              removeParticipantOnPressed(participant);
                            },
                            child: const Text('Remove'),
                          ),
                        ],
                      );
                    },
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
