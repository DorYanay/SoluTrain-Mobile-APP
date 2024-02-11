import 'package:flutter/material.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late TextEditingController dateController;
  late TextEditingController regionController;
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController startHourController;
  late TextEditingController endHourController;
  late TextEditingController maxMembersController; // Changed field name
  List<String> participants = ['Participant 1', 'Participant 2'];

  Map<String, bool> editableMap = {
    'Date': false,
    'Region': false,
    'City': false,
    'Street': false,
    'Start Hour': false,
    'End Hour': false,
    'Max Members Allowed': false, // Changed field name
  };

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: '2024-02-10');
    regionController = TextEditingController(text: 'Region');
    cityController = TextEditingController(text: 'City');
    streetController = TextEditingController(text: 'Street');
    startHourController = TextEditingController(text: '10:00 AM');
    endHourController = TextEditingController(text: '11:00 AM');
    maxMembersController =
        TextEditingController(text: '10'); // Initialize the controller
  }

  @override
  void dispose() {
    dateController.dispose();
    regionController.dispose();
    cityController.dispose();
    streetController.dispose();
    startHourController.dispose();
    endHourController.dispose();
    maxMembersController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _toggleEdit(String fieldName) {
    setState(() {
      editableMap[fieldName] = !editableMap[fieldName]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Group Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ..._buildEditableFieldRow('Date', dateController),
            const SizedBox(height: 20),
            ..._buildEditableFieldRow('Region', regionController),
            const SizedBox(height: 20),
            ..._buildEditableFieldRow('City', cityController),
            const SizedBox(height: 20),
            ..._buildEditableFieldRow('Street', streetController),
            const SizedBox(height: 20),
            ..._buildEditableFieldRow('Start Hour', startHourController),
            const SizedBox(height: 20),
            ..._buildEditableFieldRow('End Hour', endHourController),
            const SizedBox(height: 20),
            ..._buildEditableFieldRow('Max Members Allowed',
                maxMembersController), // Changed field name
            const SizedBox(height: 20),
            const Text('Participants',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: participants
                      .map((participant) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(participant),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed:
                                    () {}, // Add functionality to remove participant
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEditableFieldRow(
      String fieldName, TextEditingController controller) {
    return [
      Row(
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: controller,
              readOnly: !editableMap[fieldName]!,
              decoration: InputDecoration(
                labelText: fieldName,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          const SizedBox(
              width: 10), // Add some spacing between the text field and button
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => _toggleEdit(fieldName),
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    ];
  }
}
