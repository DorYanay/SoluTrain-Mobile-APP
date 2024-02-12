import 'package:flutter/material.dart';

class ViewTrainerPage extends StatefulWidget {
  final String trainerId;
  final String groupId;
  final String? meetingId;

  const ViewTrainerPage(this.trainerId, this.groupId, this.meetingId,
      {super.key});

  @override
  State<ViewTrainerPage> createState() => _ViewTrainerPageState();
}

class _ViewTrainerPageState extends State<ViewTrainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Trainer'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text("View Trainer"),
      ),
    );
  }
}
