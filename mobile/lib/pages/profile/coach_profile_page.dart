import 'package:flutter/material.dart';
import 'package:mobile/formaters.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../app_model.dart';

class CoachProfilePage extends StatefulWidget {
  const CoachProfilePage({super.key});

  @override
  State<CoachProfilePage> createState() => _CoachProfilePage();
}

List<String> certificates = [
  "Certificate 1",
  "Certificate 2",
  "Certificate 3"
]; // Example list of certificates

class _CoachProfilePage extends State<CoachProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserSchema user = Provider.of<AppModel>(context).user!;
    String description = user.description;
    int age = calculateAge(user.dateOfBirth);
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
              const Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('lib/images/handsomeGuy.jpg'),
                  radius: 80.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                      fontSize: 14.0,
                    ),
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.edit))
                ],),
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
                      Row(
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                              fontSize: 16.0,
                            ),
                          ),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit))
                        ],
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
                                _showCertificateDialog(
                                    context, certificates[0], user);
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
                        Row(children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                              fontSize: 16.0,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _showEditDescriptionDialog(context, user);
                              },
                              icon: const Icon(Icons.edit))
                        ]),
                        ReadMoreText(
                          '$description',
                          trimLines: 1,
                          preDataTextStyle: TextStyle(color: Colors.white),
                          postDataTextStyle: TextStyle(color: Colors.white),
                          delimiterStyle: TextStyle(color: Colors.white),
                          lessStyle: TextStyle(color: Colors.white),
                          moreStyle: TextStyle(color: Colors.white),
                          colorClickableText: Colors.amber,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: "Read more...",
                          style: TextStyle(
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
                        Row(
                          children: [
                            const Text(
                              'Personal Details',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                                fontSize: 16.0,
                              ),
                            ),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.edit))
                          ],
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
                  Column(
                    children: [
                      if (user.isCoach)
                        Row(
                          children: [
                            const Text(
                              "Groups",
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                                fontSize: 12.0,
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.remove_red_eye))
                          ],
                        ),
                    ],
                  )
                ],
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[800],
              ),
              Row(
                children: [
                  const Text(
                    'Contact',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                      fontSize: 16.0,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                ],
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

void _showEditDescriptionDialog(BuildContext context, UserSchema user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Description'),
        content: TextField(
          controller: TextEditingController(text: user.name),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 10, // Allows the TextField to expand vertically
          decoration: const InputDecoration(
            hintText: 'Enter your description...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Add functionality to save edited description
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              // Add functionality to cancel editing
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _showCertificateDialog(
    BuildContext context, String certificate, UserSchema user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Certificates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: certificates.map((certificate) {
            return ListTile(
              title: Text(certificate),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      // Add functionality to download certificate
                    },
                    icon: const Icon(Icons.download),
                  ),
                  if (user
                      .isCoach) // Conditionally show delete button based on user.isCoach
                    IconButton(
                      onPressed: () {
                        // Add functionality to delete certificate
                      },
                      icon: const Icon(Icons.delete),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Add functionality to close dialog
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
