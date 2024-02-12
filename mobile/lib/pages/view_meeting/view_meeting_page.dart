import 'package:flutter/material.dart';

class ViewMeetingPage extends StatefulWidget {
  final String meetingId;
  final String groupId;

  const ViewMeetingPage(this.meetingId, this.groupId, {super.key});

  @override
  State<ViewMeetingPage> createState() => _ViewMeetingPageState();
}

class _ViewMeetingPageState extends State<ViewMeetingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Meeting'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text("View Meeting"),
      ),
    );
  }
}
