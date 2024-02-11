import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class CreateMeetingPage extends StatefulWidget {
  const CreateMeetingPage({super.key});

  @override
  _CreateMeetingPageState createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  late TextEditingController _MeetingNameController;
  AreaSchema? _selectedRegion; // Default value
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _MeetingNameController = TextEditingController();
    _descriptionController = TextEditingController();
    // _selectedRegion = Provider.of<AppModel>(context, listen: false).areas.first; // Set initial value
  }

  @override
  void dispose() {
    _MeetingNameController.dispose();
    _descriptionController.dispose();
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
              controller: _MeetingNameController,
              decoration: const InputDecoration(
                labelText: 'Meeting Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<AreaSchema?>(
              value: _selectedRegion,
              onChanged: (AreaSchema? newValue) {
                setState(() {
                  _selectedRegion = newValue;
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
              controller: _descriptionController,
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
                if (_MeetingNameController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
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
                _MeetingNameController.clear();
                _descriptionController.clear();

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
