import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class ViewGroupPage extends StatefulWidget {
  final String groupId;

  const ViewGroupPage(this.groupId, {super.key});

  @override
  State<ViewGroupPage> createState() => _ViewGroupPageState();
}

class _ViewGroupPageState extends State<ViewGroupPage> {
  GroupViewInfoSchema? groupViewInfo;

  String getMeetingTitle(MeetInfoSchema meeting) {
    final month = meeting.meetDate.month.toString().padLeft(2, '0');
    final day = meeting.meetDate.day.toString().padLeft(2, '0');

    return '$month/$day';
  }

  void viewMeetingOnPressed(MeetInfoSchema meeting) {}

  @override
  void initState() {
    super.initState();

    API.post(context, '/group/get', params: {
      'group_id': widget.groupId,
    }).then((Response res) {
      if (res.hasError) {
        return;
      }

      setState(() {
        groupViewInfo = GroupViewInfoSchema.fromJson(res.data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (groupViewInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Group'),
        ),
        body: const Text("Loading"),
      );
    }

    final areas = Provider.of<AppModel>(context).areas;

    final area = areas
        .where((element) => element.areaId == groupViewInfo!.group.areaId)
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
              'Group Name: ${groupViewInfo!.group.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Leader: ${groupViewInfo!.group.coachName}',
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Meetings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Meetings List
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: groupViewInfo!.meets.length,
                    itemBuilder: (context, index) {
                      final meeting = groupViewInfo!.meets[index];
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
          ],
        ),
      ),
    );
  }
}
