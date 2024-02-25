import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class CreateMeetingPage extends StatefulWidget {
  final meetingOpeningDayLimit = 60;

  final String groupId;

  const CreateMeetingPage(this.groupId, {super.key});

  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  late TextEditingController maxMembersController= TextEditingController();

  void datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: widget.meetingOpeningDayLimit)),

    )
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
              controller: maxMembersController,
              decoration: const InputDecoration(
                labelText: 'Date',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
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
