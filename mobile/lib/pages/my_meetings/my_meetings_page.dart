import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:mobile/api.dart';

class MyMeetingsPage extends StatefulWidget {
  const MyMeetingsPage({super.key});

  @override
  State<MyMeetingsPage> createState() => _MyMeetingsPageState();
}

class _MyMeetingsPageState extends State<MyMeetingsPage> {
  MyMeetsSchema? meetings;

  int _compareToMeetings(MeetInfoSchema a, MeetInfoSchema b) {
    if (a.meetDate.compareTo(b.meetDate) == 0) {
      return a.meetDate.compareTo(b.meetDate);
    }
    return a.startTime.compareTo(b.startTime);
  }

  @override
  void initState() {
    super.initState();
    API.post(context, '/my-meets/get').then((Response res) {
      if (res.hasError) {
        return;
      }

      setState(() {
        meetings = MyMeetsSchema.fromJson(res.data);
      });
    });
  }

  void viewMeetingOnPressed(MeetInfoSchema meeting) {
    Provider.of<AppModel>(context, listen: false)
        .moveToViewMeetingPage(meeting.meetId, meeting.groupId);
  }

  @override
  Widget build(BuildContext context) {
    if (meetings == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meetings'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    meetings!.meets.sort(_compareToMeetings);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Meetings'),
        ),
        body: ListView.builder(
          itemCount: meetings!.meets.length,
          itemBuilder: (context, index) {
            final meeting = meetings!.meets[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: ListTile(
                  title: Text(
                    '${meeting.groupName} Meeting ${(DateFormat('dd-MM-yyyy').format(meeting.meetDate))}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: ${meeting.city}, ${meeting.street}'),
                      Text(
                          'Time: ${meeting.startTime.hour}:${meeting.startTime.minute.toString().padLeft(2, '0')} - ${meeting.endTime.hour}:${meeting.endTime.minute.toString().padLeft(2, '0')}'),
                      Text('Duration: ${meeting.duration} minutes'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      viewMeetingOnPressed(meeting);
                    },
                  ),
                ),
              ),
            );
          },
        ));
  }
}
