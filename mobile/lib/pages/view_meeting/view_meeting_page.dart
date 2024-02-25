import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/schemas.dart';

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
            const Text('Group Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
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
            Text('Start Time ${meet!.startTime.toString().split(' ')[1]}'),
            const SizedBox(height: 20),
            Text('End Time ${meet!.endTime.toString().split(' ')[1]}'),
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
