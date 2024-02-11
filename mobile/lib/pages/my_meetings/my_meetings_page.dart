import 'package:flutter/material.dart';

class Meeting {
  final String date;
  final String day;
  final String hour;
  final String description;

  Meeting({
    required this.date,
    required this.day,
    required this.hour,
    required this.description,
  });
}

class MyMeetingsPage extends StatefulWidget {
  const MyMeetingsPage({super.key});

  @override
  State<MyMeetingsPage> createState() => _MyMeetingsPageState();
}

class _MyMeetingsPageState extends State<MyMeetingsPage> {
  final List<Meeting> meetings = [
    Meeting(
        date: '2024-02-10',
        day: 'Monday',
        hour: '10:00 AM',
        description: 'Team Meeting'),
    Meeting(
        date: '2024-02-12',
        day: 'Wednesday',
        hour: '2:00 PM',
        description: 'Client Presentation'),
    Meeting(
        date: '2024-02-14',
        day: 'Friday',
        hour: '9:00 AM',
        description: 'Project Review'),
    Meeting(
        date: '2024-02-11',
        day: 'Tuesday',
        hour: '11:30 AM',
        description: 'Product Demo'),
    Meeting(
        date: '2024-02-13',
        day: 'Thursday',
        hour: '3:00 PM',
        description: 'Brainstorming Session'),
    Meeting(
        date: '2024-02-15',
        day: 'Saturday',
        hour: '10:00 AM',
        description: 'Training Workshop'),
    Meeting(
        date: '2024-02-16',
        day: 'Sunday',
        hour: '1:00 PM',
        description: 'Weekly Review Meeting'),
    Meeting(
        date: '2024-02-17',
        day: 'Monday',
        hour: '9:00 AM',
        description: 'Project Kickoff'),
    Meeting(
        date: '2024-02-19',
        day: 'Wednesday',
        hour: '4:30 PM',
        description: 'Client Feedback Session'),
    Meeting(
        date: '2024-02-20',
        day: 'Thursday',
        hour: '12:00 PM',
        description: 'Lunch Meeting'),
    Meeting(
        date: '2024-02-21',
        day: 'Friday',
        hour: '3:30 PM',
        description: 'Team Building Activity'),
    Meeting(
        date: '2024-02-22',
        day: 'Saturday',
        hour: '2:30 PM',
        description: 'Quarterly Planning Meeting'),
  ];

  @override
  Widget build(BuildContext context) {
    meetings.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetings'),
      ),
      body: ListView.builder(
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ListTile(
                title: Text(
                  '${meeting.date}, ${meeting.day}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time: ${meeting.hour}'),
                    Text('Description: ${meeting.description}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Navigate to meeting page here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeetingPage(
                          meeting: meeting,
                          onMeetingCancelled: () {
                            // Remove the cancelled meeting from the list
                            setState(() {
                              meetings.remove(meeting);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MeetingPage extends StatelessWidget {
  final Meeting meeting;
  final VoidCallback onMeetingCancelled;

  const MeetingPage({
    Key? key,
    required this.meeting,
    required this.onMeetingCancelled,
  }) : super(key: key);

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
            Text('Date: ${meeting.date}'),
            Text('Day: ${meeting.day}'),
            Text('Hour: ${meeting.hour}'),
            Text('Description: ${meeting.description}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement cancellation logic here
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cancel Meeting'),
                    content: const Text(
                        'Are you sure you want to cancel this meeting?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement cancellation logic here
                          Navigator.pop(context); // Close the dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Meeting cancelled'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          // Call the callback function to notify the parent page
                          onMeetingCancelled();
                        },
                        child: const Text('Yes, Cancel'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Cancel Meeting'),
            ),
          ],
        ),
      ),
    );
  }
}
