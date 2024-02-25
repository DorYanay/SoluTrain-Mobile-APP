import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

String timeOfDayToText(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

class CreateMeetingPage extends StatefulWidget {
  final meetingOpeningDayLimit = 60;

  final String groupId;

  const CreateMeetingPage(this.groupId, {super.key});

  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  late TextEditingController maxMembersController= TextEditingController();
  late TextEditingController dateController = TextEditingController(text: DateTime.now().toString().split(" ")[0]);
  DateTime date = DateTime.now();
  late TextEditingController startTimeController = TextEditingController(text: timeOfDayToText(TimeOfDay.now()));
  TimeOfDay startTime = TimeOfDay.now();
  late TextEditingController endTimeController = TextEditingController(text: timeOfDayToText(TimeOfDay.now()));
  TimeOfDay endTime = TimeOfDay.now();
  late TextEditingController cityController = TextEditingController();
  late TextEditingController streetController = TextEditingController();

  void datePickerOnTap() {
    showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: widget.meetingOpeningDayLimit)),
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
    showTimePicker(
      context: context,
      initialTime: startTime,
    ).then((TimeOfDay? value) {
      if (value == null) {
        return;
      }

      setState(() {
        startTime = value;
        startTimeController.text = timeOfDayToText(value);
      });
    });
  }

  void endTimePickerOnTap() {
    showTimePicker(
      context: context,
      initialTime: endTime,
    ).then((TimeOfDay? value) {
      if (value == null) {
        return;
      }

      setState(() {
        endTime = value;
        endTimeController.text = timeOfDayToText(value);
      });
    });
  }

  void createMeetingOnPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Meeting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: maxMembersController,
              decoration: const InputDecoration(
                labelText: 'Max Members',
                border: OutlineInputBorder(),
              ),
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
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: streetController,
              decoration: const InputDecoration(
                labelText: "Street",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createMeetingOnPressed,
              child: const Text('Create Meeting'),
            ),
          ],
        ),
      ),
    );
  }
}
