import 'package:flutter/material.dart';
import 'package:mobile/pages/view_coach/coach_cartificates_view.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import 'package:mobile/app_model.dart';
import 'package:mobile/formaters.dart';

import '../../api.dart';

class ViewCoachPage extends StatefulWidget {
  final String coachId;
  final String groupId;
  final String? meetingId;

  const ViewCoachPage(this.coachId, this.groupId, this.meetingId, {super.key});

  @override
  State<ViewCoachPage> createState() => _ViewCoachPage();
}

class _ViewCoachPage extends State<ViewCoachPage> {
  void showCertificatesOnPressed() {
    String userAutoToken =
        Provider.of<AppModel>(context, listen: false).authToken!;

    CoachCertificatesView.open(context, userAutoToken);
  }

  @override
  Widget build(BuildContext context) {
    UserSchema user = Provider.of<AppModel>(context).user!;

    String authToken = Provider.of<AppModel>(context).authToken!;

    String imageUrl = API.getURL('/profile/get-profile-picture', authToken);

    int age = calculateAge(user.dateOfBirth);

    String description = user.description;

    String gender = user.gender;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Coach Profile',
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
              // First column: Code
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 2.0,
                          fontSize: 16.0,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "View Certificates",
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                              fontSize: 12.0,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showCertificatesOnPressed();
                              },
                              icon: const Icon(Icons.remove_red_eye))
                        ],
                      ),
                    ],
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        letterSpacing: 2.0,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 2.0,
                            fontSize: 16.0,
                          ),
                        ),
                        ReadMoreText(
                          description,
                          trimLines: 1,
                          preDataTextStyle:
                              const TextStyle(color: Colors.white),
                          postDataTextStyle:
                              const TextStyle(color: Colors.white),
                          delimiterStyle: const TextStyle(color: Colors.white),
                          lessStyle: const TextStyle(color: Colors.white),
                          moreStyle: const TextStyle(color: Colors.white),
                          colorClickableText: Colors.amber,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: "Read more...",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          trimExpandedText: "Less...",
                        ),
                      ])
                ],
              ),
              // Second column: ElevatedButton

              Divider(
                height: 10.0,
                color: Colors.grey[800],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First column: Code
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Details',
                          style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 2.0,
                            fontSize: 16.0,
                          ),
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
                              user.gender,
                              style: TextStyle(
                                  color: Colors.amberAccent[200],
                                  letterSpacing: 2.0,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Second column: ElevatedButton
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
                    user.email,
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
                    user.phone,
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
