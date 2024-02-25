import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

String timeToText(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

class ViewMeetingPage extends StatefulWidget {
  final String meetingId;
  final String groupId;

  const ViewMeetingPage(this.meetingId, this.groupId, {super.key});

  @override
  State<ViewMeetingPage> createState() => _ViewMeetingPageState();
}

class _ViewMeetingPageState extends State<ViewMeetingPage> {
  MeetInfoSchema? meet;

  bool waitingForRequest = false;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void refresh() {
    setState(() {
      waitingForRequest = true;
    });

    API.post(context, '/my-meets/get-meeting', params: {
      'meet_id': widget.meetingId,
    }).then((Response res) {
      setState(() {
        waitingForRequest = false;
      });

      if (res.hasError) {
        return;
      }

      setState(() {
        meet = MeetInfoSchema.fromJson(res.data);
      });
    });
  }

  void groupNameOnnPressed() {
    if (meet == null) {
      return;
    }

    Provider.of<AppModel>(context, listen: false)
        .moveToViewGroupPage(meet!.groupId, false);
  }

  void registerMeetingOnPressed() {
    if (waitingForRequest) {
      return;
    }

    setState(() {
      waitingForRequest = true;
    });

    if (meet!.registered) {
      // unregister to group
      API.post(context, '/group/unregister-to-meet', params: {
        'meet_id': widget.meetingId,
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
      API.post(context, '/group/register-to-meet', params: {
        'meet_id': widget.meetingId,
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

  @override
  Widget build(BuildContext context) {
    if (meet == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meeting Details'),
        ),
        body: const Text("Loading..."),
      );
    }

    final meetFullText = meet!.full ? 'The meet is full' : '';
    final registerButtonText = meet!.registered ? "Unregister" : "Register";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20),
              ),
              onPressed: groupNameOnnPressed,
              child: Text(meet!.groupName),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: registerMeetingOnPressed,
                child: Column(
                  children: [
                    Text(registerButtonText),
                  ],
                )),
            const SizedBox(height: 20),
            Text('Date ${meet!.meetDate.toString().split(' ')[0]}'),
            const SizedBox(height: 20),
            Text('Start Time ${timeToText(meet!.startTime)}'),
            const SizedBox(height: 20),
            Text('End Time ${timeToText(meet!.endTime)}'),
            const SizedBox(height: 20),
            Text('City: ${meet!.city}'),
            const SizedBox(height: 20),
            Text('Street: ${meet!.street}'),
            const SizedBox(height: 20),
            Text(meetFullText),
          ],
        ),
      ),
    );
  }
}
