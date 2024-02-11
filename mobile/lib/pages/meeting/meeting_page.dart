import 'package:flutter/material.dart';

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late TextEditingController _dateController;
  late TextEditingController _regionController;
  late TextEditingController _cityController;
  late TextEditingController _streetController;
  late TextEditingController _startHourController;
  late TextEditingController _endHourController;
  late TextEditingController _maxMembersController; // Changed field name
  List<String> _participants = ['Participant 1', 'Participant 2'];

  Map<String, bool> _editableMap = {
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
    _dateController = TextEditingController(text: '2024-02-10');
    _regionController = TextEditingController(text: 'Region');
    _cityController = TextEditingController(text: 'City');
    _streetController = TextEditingController(text: 'Street');
    _startHourController = TextEditingController(text: '10:00 AM');
    _endHourController = TextEditingController(text: '11:00 AM');
    _maxMembersController =
        TextEditingController(text: '10'); // Initialize the controller
  }

  @override
  void dispose() {
    _dateController.dispose();
    _regionController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _startHourController.dispose();
    _endHourController.dispose();
    _maxMembersController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _toggleEdit(String fieldName) {
    setState(() {
      _editableMap[fieldName] = !_editableMap[fieldName]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Group Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ..._buildEditableFieldRow('Date', _dateController),
            SizedBox(height: 20),
            ..._buildEditableFieldRow('Region', _regionController),
            SizedBox(height: 20),
            ..._buildEditableFieldRow('City', _cityController),
            SizedBox(height: 20),
            ..._buildEditableFieldRow('Street', _streetController),
            SizedBox(height: 20),
            ..._buildEditableFieldRow('Start Hour', _startHourController),
            SizedBox(height: 20),
            ..._buildEditableFieldRow('End Hour', _endHourController),
            SizedBox(height: 20),
            ..._buildEditableFieldRow('Max Members Allowed',
                _maxMembersController), // Changed field name
            SizedBox(height: 20),
            Text('Participants',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _participants
                      .map((participant) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(participant),
                              IconButton(
                                icon: Icon(Icons.delete),
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
              readOnly: !_editableMap[fieldName]!,
              decoration: InputDecoration(
                labelText: fieldName,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          SizedBox(
              width: 10), // Add some spacing between the text field and button
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => _toggleEdit(fieldName),
              icon: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    ];
  }
}

void main() {
  runApp(MaterialApp(
    home: MeetingPage(),
  ));
}
