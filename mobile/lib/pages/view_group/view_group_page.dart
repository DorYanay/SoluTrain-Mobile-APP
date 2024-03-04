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

    final hour = meeting.meetDate.hour.toString().padLeft(2, '0');
    final minute = meeting.meetDate.minute.toString().padLeft(2, '0');

    return '$month/$day $hour:$minute In ${meeting.city}, ${meeting.street}';
  }

  void leadingPageOnPressed() {
    if (groupViewInfo == null) {
      return;
    }

    if (widget.fromSearchGroups) {
      final areas = Provider.of<AppModel>(context, listen: false).areas;

      final area = areas
          .where((element) => element.areaId == groupViewInfo!.group.areaId)
          .toList();

      Provider.of<AppModel>(context, listen: false)
          .moveToSearchGroupPage(area[0]);
    } else {
      Provider.of<AppModel>(context, listen: false).moveToMyGroupsPage();
    }
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

  void viewCoachOnPressed() {
    Provider.of<AppModel>(context, listen: false).moveToViewCoachPage(
        groupViewInfo!.group.coachId, groupViewInfo!.group.groupId, null);
  }

  void viewMeetingOnPressed(MeetInfoSchema meeting) {
    if (!groupViewInfo!.registered) {
      return;
    }

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
        leading: ((widget.fromSearchGroups)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: leadingPageOnPressed,
              )
            : null),
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
            Row(
              children: [
                const Text(
                  'Coach:',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  onPressed: viewCoachOnPressed,
                  child: Text(groupViewInfo!.group.coachName),
                ),
              ],
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: groupViewInfo!.registered
                                  ? null
                                  : Colors.grey,
                            ),
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
