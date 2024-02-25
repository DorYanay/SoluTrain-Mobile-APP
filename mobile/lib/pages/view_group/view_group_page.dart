import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class ViewGroupPage extends StatefulWidget {
  final String groupId;
  final bool fromSearchGroups;

  const ViewGroupPage(this.groupId, this.fromSearchGroups, {super.key});

  @override
  State<ViewGroupPage> createState() => _ViewGroupPageState();
}

class _ViewGroupPageState extends State<ViewGroupPage> {
  GroupViewInfoSchema? groupViewInfo;

  bool waitingForRequest = false;

  String getMeetingTitle(MeetInfoSchema meeting) {
    final month = meeting.meetDate.month.toString().padLeft(2, '0');
    final day = meeting.meetDate.day.toString().padLeft(2, '0');

    return '$month/$day';
  }

  void registerGroupOnPressed() {
    if (waitingForRequest) {
      return;
    }

    setState(() {
      waitingForRequest = true;
    });

    if (groupViewInfo!.registered) {
      // unregister to group
      API.post(context, '/group/unregister-to-group', params: {
        'group_id': groupViewInfo!.group.groupId,
      }).then((Response res) {
        setState(() {
          waitingForRequest = false;
        });

        if (res.hasError) {
          return;
        }

        refresh();
      });
    } else {
      // register to group
      API.post(context, '/group/register-to-group', params: {
        'group_id': groupViewInfo!.group.groupId,
      }).then((Response res) {
        setState(() {
          waitingForRequest = false;
        });

        if (res.hasError) {
          return;
        }

        refresh();
      });
    }
  }

  void viewMeetingOnPressed(MeetInfoSchema meeting) {
    Provider.of<AppModel>(context, listen: false)
        .moveToViewMeetingPage(meeting.meetId, meeting.groupId);
  }

  void refresh() {
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
  void initState() {
    super.initState();

    refresh();
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

    final registerButtonText =
        groupViewInfo!.registered ? "Unregister" : "Register";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Group Name: ${groupViewInfo!.group.name}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                    onPressed: registerGroupOnPressed,
                    child: Column(
                      children: [
                        Text(registerButtonText),
                      ],
                    )),
              ],
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
