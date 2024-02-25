import 'package:flutter/material.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

import 'package:mobile/app_model.dart';
import 'package:mobile/formaters.dart';
import 'package:mobile/api.dart';

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
  UserBaseSchema? trainer;

  @override
  Widget build(BuildContext context) {
    if (trainer == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('View Trainer'),
        ),
        body: const Text("Loading..."),
      );
    }

    String authToken = Provider.of<AppModel>(context).authToken!;

    String imageUrl = API.getURL('/profile/get-profile-picture', authToken);

    int age = calculateAge(trainer!.dateOfBirth);

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text(
          'View Trainer',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      radius: 80.0,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[800],
              ),
              // Each Row contains the code in the first column and an ElevatedButton in the second column
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    trainer!.name,
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        letterSpacing: 2.0,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                'Personal Details',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Row(
                children: [
                  Text(
                    'Age:',
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2.0,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$age',
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        letterSpacing: 2.0,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Gender:',
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2.0,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    trainer!.gender,
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        letterSpacing: 2.0,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[800],
              ),
              const Text(
                'Contact',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.grey[400],
                    size: 35.0,
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  Text(
                    'Email', // Change to user.email or appropriate data
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    trainer!.email,
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        letterSpacing: 2.0,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: Colors.grey[400],
                    size: 35.0,
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  Text(
                    'Phone', // Change to user.phone or appropriate data
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    trainer!.phone,
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        letterSpacing: 2.0,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ]),
      ),
    ); //scaffold
  }
}
