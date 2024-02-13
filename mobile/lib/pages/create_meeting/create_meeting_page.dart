import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class CreateMeetingPage extends StatefulWidget {
  final String groupId;

  const CreateMeetingPage(this.groupId, {super.key});

  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  late TextEditingController meetingNameController;
  AreaSchema? selectedRegion;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    meetingNameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    meetingNameController.dispose();
    descriptionController.dispose();
    super.dispose();
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
              controller: meetingNameController,
              decoration: const InputDecoration(
                labelText: 'Meeting Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<AreaSchema?>(
              value: selectedRegion,
              onChanged: (AreaSchema? newValue) {
                setState(() {
                  selectedRegion = newValue;
                });
              },
              items: Provider.of<AppModel>(context)
                  .areas
                  .map<DropdownMenuItem<AreaSchema?>>((AreaSchema area) {
                return DropdownMenuItem<AreaSchema?>(
                  value: area,
                  child: Text(area.name), // Display the option text
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validate input and save the Meeting
                if (meetingNameController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                    ),
                  );
                  return;
                }

                // Save the Meeting or perform any necessary action
                // For example, you can send the Meeting data to the server

                // Clear text fields after saving
                meetingNameController.clear();
                descriptionController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meeting created successfully!'),
                  ),
                );
              },
              child: const Text('Create Meeting'),
            ),
          ],
        ),
      ),
    );
  }
}
