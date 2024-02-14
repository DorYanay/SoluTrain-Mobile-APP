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

  void uploadCertificateOnPressed() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;
      print(filePath);
    }
    // TODO: this is ori :)
    // TODO: remaining to push the file into the database and change to isCoach to true
    // API.guestPost('/debug/make-coach', params: {
    //   'email': Provider.of<AppModel>(context, listen: false).user!.email,
    // }).then((Response res) {
    //   API.post(context, '/auth/logout').then((value) {
    //     Provider.of<AppModel>(context, listen: false).setLogout();
    //   }).onError((error, stackTrace) {
    //     Provider.of<AppModel>(context, listen: false).setLogout();
    //   });
    // });


  }
  void uploadImageOnPressed() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;
      print(filePath);
    }
  }

    @override
  Widget build(BuildContext context) {
    UserSchema user = Provider.of<AppModel>(context, listen: true).user!;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                      fontSize: 14.0,
                    ),
                  ),
                  IconButton(onPressed: () {
                    TextEditingController nameController = TextEditingController(text: null);
                    TextEditingController emailController = TextEditingController(text: null);
                    TextEditingController phoneController = TextEditingController(text: null);
                    TextEditingController genderController = TextEditingController(text: null);
                    DateTime initialDateOfBirth = user.dateOfBirth ?? DateTime.now();
                    DateTime selectedDateOfBirth = initialDateOfBirth;

                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Edit Details'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              TextFormField(
                                decoration: const InputDecoration(labelText: 'Date of Birth'),
                                initialValue: selectedDateOfBirth.toString(), // Set initial value
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: dialogContext,
                                    initialDate: selectedDateOfBirth ?? DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    // Update selectedDateOfBirth when date is picked
                                    selectedDateOfBirth = pickedDate;
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: genderController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                UserSchema updatedUser = UserSchema(user.userId, nameController.text, emailController.text, phoneController.text, genderController.text, selectedDateOfBirth, "", user.isCoach);

                                API.post(context, '/profile/update-details', params: {
                                  "new_name": updatedUser.name,
                                  "new_email": updatedUser.email,
                                  "new_phone": updatedUser.phone,
                                })
                                    .then((Response res) {
                                  if (res.hasError) {
                                    return;
                                  }

                                  setState(() {
                                    Provider.of<AppModel>(context, listen: false).setUser(updatedUser);
                                    Navigator.of(context).pop(updatedUser);
                                  });
                                });

                              },
                              child: const Text('Save'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                              icon: const Icon(Icons.edit))
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
