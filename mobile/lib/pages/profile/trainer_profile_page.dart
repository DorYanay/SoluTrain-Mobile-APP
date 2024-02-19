import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile/api.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

import 'package:mobile/app_model.dart';
import 'package:mobile/formaters.dart';

class TrainerProfilePage extends StatefulWidget {
  const TrainerProfilePage({super.key});

  @override
  State<TrainerProfilePage> createState() => _TrainerProfilePageState();
}

class _TrainerProfilePageState extends State<TrainerProfilePage> {
  void uploadCertificateOnPressed() {
    FilePicker.platform.pickFiles().then((FilePickerResult? result) {
      if (result?.files.single.path != null) {
        String filePath = result!.files.single.path!;

        API
            .post(context, '/profile/upload-first-certificate',
                filePath: filePath)
            .then((Response res) {
          API.post(context, '/auth/logout').then((Response res2) {
            Provider.of<AppModel>(context, listen: false).setLogout();
          }).onError((error, stackTrace) {
            Provider.of<AppModel>(context, listen: false).setLogout();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserSchema user = Provider.of<AppModel>(context).user!;
    int age = calculateAge(user.dateOfBirth);
    String gender = user.gender;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Profile',
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
                child: CircleAvatar(
                  backgroundImage: AssetImage(gender=='male' ? 'lib/images/avatar_man_image.png' : 'lib/images/avatar_woman_image.png'),
                  radius: 80.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                      fontSize: 14.0,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                ],
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
                  // First column: Code
                  Column(
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
                        user.name,
                        style: TextStyle(
                            color: Colors.amberAccent[200],
                            letterSpacing: 2.0,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // Second column: ElevatedButton
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: uploadCertificateOnPressed,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white70, // Background color
                          onPrimary: Colors.black, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6), // Padding
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_box), // Icon
                            SizedBox(width: 4), // Spacing between icon and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upload certificate',
                                  style: TextStyle(fontSize: 16), // Text style
                                ),
                                Text(
                                  'to become coach',
                                  style: TextStyle(fontSize: 16), // Text style
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    user.gender,
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

bool isValidPhoneNumber(String phoneNumber) {
  if (!_containsOnlyDigits(phoneNumber.replaceAll('+', '')) &&
      !phoneNumber.startsWith('+')) {
    return false;
  }

  if (phoneNumber.length < 10 || phoneNumber.length > 14) {
    return false;
  }

  return true;
}

bool _containsOnlyDigits(String str) {
  for (int i = 0; i < str.length; i++) {
    if (!isDigit(str[i])) {
      return false;
    }
  }
  return true;
}

bool isDigit(String s) {
  return double.tryParse(s) != null;
}
