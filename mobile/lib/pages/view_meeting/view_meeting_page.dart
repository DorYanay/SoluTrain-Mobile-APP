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
  MeetViewInfoSchema? viewMeet;

  bool waitingForRequest = false;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void leadingPageOnPressed() {
    Provider.of<AppModel>(context, listen: false)
        .moveToViewGroupPage(widget.groupId, false);
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
        viewMeet = MeetViewInfoSchema.fromJson(res.data);
      });
    });
  }

  void groupNameOnPressed() {
    if (viewMeet == null) {
      return;
    }

    Provider.of<AppModel>(context, listen: false)
        .moveToViewGroupPage(viewMeet!.meet.groupId, false);
  }

  void coachNameOnPressed() {
    if (viewMeet == null) {
      return;
    }

    Provider.of<AppModel>(context, listen: false).moveToViewCoachPage(
        viewMeet!.group.coachId, widget.groupId, widget.meetingId);
  }

  void registerMeetingOnPressed() {
    if (waitingForRequest) {
      return;
    }

    setState(() {
      waitingForRequest = true;
    });

    if (viewMeet!.meet.registered) {
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
    if (viewMeet == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meeting Details'),
        ),
        body: const Text("Loading..."),
      );
    }

    final meetFullText = viewMeet!.meet.full ? 'The meet is full' : '';
    final registerButtonText =
        viewMeet!.meet.registered ? "Unregister" : "Register";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: leadingPageOnPressed,
        ),
        title: const Text('Meeting Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: groupNameOnPressed,
              child: Text(viewMeet!.meet.groupName),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: coachNameOnPressed,
              child: Text(viewMeet!.group.coachName),
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
            Text('Date ${viewMeet!.meet.meetDate.toString().split(' ')[0]}'),
            const SizedBox(height: 20),
            Text('Start Time ${timeToText(viewMeet!.meet.startTime)}'),
            const SizedBox(height: 20),
            Text('End Time ${timeToText(viewMeet!.meet.endTime)}'),
            const SizedBox(height: 20),
            Text('City: ${viewMeet!.meet.city}'),
            const SizedBox(height: 20),
            Text('Street: ${viewMeet!.meet.street}'),
            const SizedBox(height: 20),
            Text(meetFullText),
          ],
        ),
      ),
    );
  }
}
