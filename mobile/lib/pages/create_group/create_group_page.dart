import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

import 'package:mobile/api.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController groupNameController = TextEditingController();
  AreaSchema? selectedRegion;
  final TextEditingController descriptionController = TextEditingController();

  bool waitingForRequest = false;

  void createGroupOnPressed() {
    if (waitingForRequest) {
      return;
    }

    if (groupNameController.text.isEmpty ||
        selectedRegion == null ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    setState(() {
      waitingForRequest = true;
    });

    API.post(context, '/create-group/create', params: {
      'name': groupNameController.text,
      'description': descriptionController.text,
      'area_id': selectedRegion!.areaId,
    }).then((Response res) {
      setState(() {
        waitingForRequest = false;
      });

      if (res.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot create the group!'),
          ),
        );

        return;
      }

      GroupSchema group = GroupSchema.fromJson(res.data);

      Provider.of<AppModel>(context, listen: false)
          .moveToGroupPage(group.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: groupNameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
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
              onPressed: createGroupOnPressed,
              child: const Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
