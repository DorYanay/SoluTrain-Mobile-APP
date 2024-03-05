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
  ViewCoachSchema? coachInfo;

  @override
  void initState() {
    super.initState();

    API.post(context, '/view-coach/get', params: {
      'coach_id': widget.coachId,
    }).then((Response res) {
      if (res.hasError) {
        return;
      }

      setState(() {
        coachInfo = ViewCoachSchema.fromJson(res.data);
      });
    });
  }

  void leadingPageOnPressed() {
    if (widget.meetingId == null) {
      Provider.of<AppModel>(context, listen: false)
          .moveToViewGroupPage(widget.groupId, false);
    } else {
      Provider.of<AppModel>(context, listen: false)
          .moveToViewMeetingPage(widget.meetingId!, widget.groupId);
    }
  }

  void showCertificatesOnPressed() {
    if (coachInfo == null) {
      return;
    }

    String userAutoToken =
        Provider.of<AppModel>(context, listen: false).authToken!;

    CoachCertificatesView.open(context, userAutoToken, coachInfo!.certificates);
  }

  @override
  Widget build(BuildContext context) {
    if (coachInfo == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: leadingPageOnPressed,
          ),
          title: const Text('Coach Profile'),
        ),
        body: const Text("Loading..."),
      );
    }

    String authToken = Provider.of<AppModel>(context).authToken!;

    String imageUrl =
        '${API.getURL('/view-coach/get-profile-picture', authToken, params: {
          'coach_id': widget.coachId,
        })}&now=${DateTime.now().millisecondsSinceEpoch.toString()}';

    int age = calculateAge(coachInfo!.coach.dateOfBirth);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: leadingPageOnPressed,
        ),
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
                    coachInfo!.coach.name,
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
                          coachInfo!.coach.description,
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
                              coachInfo!.coach.gender,
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
                    coachInfo!.coach.email,
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
                    coachInfo!.coach.phone,
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
