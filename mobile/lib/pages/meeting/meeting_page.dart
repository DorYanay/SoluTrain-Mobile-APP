import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/formaters.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

String timeOfDayToText(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

class MeetingPage extends StatefulWidget {
  final meetingOpeningDayLimit = 60;

  final String meetingId;
  final String groupId;

  const MeetingPage(this.meetingId, this.groupId, {super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  MeetSchema? meet;

  bool editMode = false;

  late TextEditingController maxMembersController = TextEditingController();
  late TextEditingController dateController =
      TextEditingController(text: DateTime.now().toString().split(" ")[0]);
  DateTime date = DateTime.now();
  late TextEditingController startTimeController =
      TextEditingController(text: timeOfDayToText(TimeOfDay.now()));
  TimeOfDay startTime = TimeOfDay.now();
  late TextEditingController endTimeController =
      TextEditingController(text: timeOfDayToText(TimeOfDay.now()));
  TimeOfDay endTime = TimeOfDay.now();
  late TextEditingController cityController = TextEditingController();
  late TextEditingController streetController = TextEditingController();

  String userMessage = "";

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void clearData() {
    setState(() {
      maxMembersController.text = meet!.maxMembers.toString();
      date = meet!.meetDate;
      dateController.text = date.toString().split(" ")[0];
      startTime = TimeOfDay.fromDateTime(meet!.startTime);
      startTimeController.text = timeOfDayToText(startTime);
      endTime = TimeOfDay.fromDateTime(meet!.endTime);
      endTimeController.text = timeOfDayToText(endTime);
      cityController.text = meet!.city;
      streetController.text = meet!.street;
    });
  }

  void refresh() {
    API.post(context, '/meet/get-as-coach', params: {
      'meet_id': widget.meetingId,
    }).then((Response res) {
      if (res.hasError) {
        return;
      }

      MeetSchema data = MeetSchema.fromJson(res.data);

      setState(() {
        meet = data;
        editMode = false;
      });

      clearData();
    });
  }

  void editOnPressed() {
    clearData();

    setState(() {
      editMode = true;
    });
  }

  void datePickerOnTap() {
    if (!editMode) {
      return;
    }

    showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(Duration(days: widget.meetingOpeningDayLimit)),
    ).then((DateTime? value) {
      if (value == null) {
        return;
      }

      setState(() {
        date = value;
        dateController.text = value.toString().split(" ")[0];
      });
    });
  }

  void startTimePickerOnTap() {
    if (!editMode) {
      return;
    }

    showTimePicker(
      context: context,
      initialTime: startTime,
    ).then((TimeOfDay? value) {
      if (value == null) {
        return;
      }

      setState(() {
        startTime = value;
        startTimeController.text = timeOfDayToText(startTime);
      });
    });
  }

  void endTimePickerOnTap() {
    if (!editMode) {
      return;
    }

    showTimePicker(
      context: context,
      initialTime: endTime,
    ).then((TimeOfDay? value) {
      if (value == null) {
        return;
      }

      setState(() {
        endTime = value;
        endTimeController.text = timeOfDayToText(endTime);
      });
    });
  }

  void updateMeetingOnPressed() {
    if (!editMode) {
      return;
    }

    if (maxMembersController.text.isEmpty) {
      setState(() {
        userMessage = "Max Members is required!";
      });
      return;
    }

    int? maxMembers = int.tryParse(maxMembersController.text);
    if (maxMembers == null || maxMembers <= 0) {
      setState(() {
        userMessage = "Max Members must be positive integer!";
      });
      return;
    }

    int duration = (endTime.hour - startTime.hour) * 60 +
        (endTime.minute - startTime.minute);

    if (duration <= 0) {
      setState(() {
        userMessage = "Start Time cannot be after End time";
      });
      return;
    }

    if (cityController.text.isEmpty) {
      setState(() {
        userMessage = "City is required!";
      });
      return;
    }

    if (streetController.text.isEmpty) {
      setState(() {
        userMessage = "Street is required!";
      });
      return;
    }

    DateTime meetFullDate = date;
    meetFullDate
        .add(Duration(hours: startTime.hour, minutes: startTime.minute));

    setState(() {
      userMessage = "";
    });

    API.post(context, '/meet/update-details', params: {
      'meet_id': widget.meetingId,
      'new_max_members': maxMembers.toString(),
      'new_date': dateTimeToAPIString(meetFullDate),
      'new_duration': duration.toString(),
      'new_city': cityController.text,
      'new_street': streetController.text,
    }).then((Response res) {
      if (res.hasError) {
        setState(() {
          userMessage = res.errorMessage;
        });
        return;
      }

      refresh();
    });
  }

  void cancelEditOnPressed() {
    if (!editMode) {
      return;
    }

    clearData();

    setState(() {
      editMode = false;
    });
  }

  void viewParticipant(UserBaseSchema participant) {
    Provider.of<AppModel>(context, listen: false).moveToViewTrainerPage(
        participant.userId, widget.groupId, widget.meetingId);
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
            if (!editMode)
              ElevatedButton(
                onPressed: editOnPressed,
                child: const Text('Edit'),
              ),
            if (!editMode) const SizedBox(height: 15),
            TextFormField(
              controller: maxMembersController,
              decoration: const InputDecoration(
                labelText: 'Max Members',
                border: OutlineInputBorder(),
              ),
              readOnly: !editMode,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: datePickerOnTap,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: startTimeController,
              decoration: const InputDecoration(
                labelText: 'Start Time',
                prefixIcon: Icon(Icons.access_time),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: startTimePickerOnTap,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: endTimeController,
              decoration: const InputDecoration(
                labelText: 'End Time',
                prefixIcon: Icon(Icons.access_time),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: endTimePickerOnTap,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
              readOnly: !editMode,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: streetController,
              decoration: const InputDecoration(
                labelText: "Street",
                border: OutlineInputBorder(),
              ),
              readOnly: !editMode,
            ),
            const SizedBox(height: 20),
            if (editMode)
              Text(
                userMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            if (editMode) const SizedBox(height: 0),
            if (editMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: cancelEditOnPressed,
                    child: const Text('Cancel Edit'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: updateMeetingOnPressed,
                    child: const Text('Update Meeting'),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            const Text('Participants',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: Column(
                children: meet!.members
                    .map((participant) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(participant.name),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                viewParticipant(participant);
                              },
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
