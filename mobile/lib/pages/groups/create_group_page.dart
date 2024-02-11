import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late TextEditingController _GroupNameController;
  AreaSchema? _selectedRegion; // Default value
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _GroupNameController = TextEditingController();
    _descriptionController = TextEditingController();
    // _selectedRegion = Provider.of<AppModel>(context, listen: false).areas.first; // Set initial value
  }

  @override
  void dispose() {
    _GroupNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _GroupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
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
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validate input and save the Group
                if (_GroupNameController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields'),
                    ),
                  );
                  return;
                }

                // Save the Group or perform any necessary action
                // For example, you can send the Group data to the server

                // Clear text fields after saving
                _GroupNameController.clear();
                _descriptionController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Group created successfully!'),
                  ),
                );
              },
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
