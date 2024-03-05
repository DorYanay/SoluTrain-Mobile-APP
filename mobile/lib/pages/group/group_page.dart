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

    final hour = meeting.startTime.hour.toString().padLeft(2, '0');
    final minute = meeting.startTime.minute.toString().padLeft(2, '0');

    return '$month/$day $hour:$minute In ${meeting.city}, ${meeting.street}';
  }

  void leadingPageOnPressed() {
    Provider.of<AppModel>(context, listen: false).moveToGroupsPage();
  }

  void createMeetingOnPressed() {
    Provider.of<AppModel>(context, listen: false)
        .moveToCreateMeetingPage(fullGroup!.group.groupId);
  }

  void viewMeetingOnPressed(MeetSchema meeting) {
    Provider.of<AppModel>(context, listen: false)
        .moveToMeetingPage(meeting.meetId, meeting.groupId);
  }

  void viewParticipantOnPressed(UserBaseSchema participant) {
    Provider.of<AppModel>(context, listen: false)
        .moveToViewTrainerPage(participant.userId, widget.groupId, null);
  }

  void removeParticipantOnPressed(UserBaseSchema participant) {
    API.post(context, '/group/remove-member', params: {
      'group_id': widget.groupId,
      'member_id': participant.userId,
    }).then((Response res) {
      if (res.hasError) {
        return;
      }

      setState(() {
        fullGroup = GroupFullSchema.fromJson(res.data);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    API.post(context, '/group/get-as-coach', params: {
      'group_id': widget.groupId,
    }).then((Response res) {
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: leadingPageOnPressed,
          ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: leadingPageOnPressed,
        ),
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
              'Coach: ${fullGroup!.group.coachName}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Region: $areaName',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const TabBar(tabs: [
                    Tab(text: "Meetings"),
                    Tab(text: "Participants"),
                  ]),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: createMeetingOnPressed,
                                    child: const Text('Create Meeting'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: fullGroup!.meets.length,
                                itemBuilder: (context, index) {
                                  final meeting = fullGroup!.meets[index];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: fullGroup!.members.length,
                                itemBuilder: (context, index) {
                                  final participant = fullGroup!.members[index];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                          textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        onPressed: () {
                                          viewParticipantOnPressed(participant);
                                        },
                                        child: Text(participant.name),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          removeParticipantOnPressed(
                                              participant);
                                        },
                                        child: const Text('Remove'),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
