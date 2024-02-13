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
                    'Edit',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                      fontSize: 14.0,
                    ),
                  ),
                  IconButton(onPressed: uploadImageOnPressed,
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
                      Row(children: [
                        const Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 2.0,
                            fontSize: 16.0,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _showEditNameDialog(context, user);
                            },
                            icon: const Icon(Icons.edit))
                      ]),
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
                          child: const Column(
                            children: [
                              Text('Upload certificate'),
                              Text('become coach'),
                              Icon(Icons.add_box) // Add button text
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[800],
              ),
              Row(children: [
                const Text(
                  'Personal Details',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _showEditPersonalDetailsDialog(context, user);
                    },
                    icon: const Icon(Icons.edit))
              ]),
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
                    'Activity level:',
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2.0,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Hard',
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
              Row(children: [
                const Text(
                  'Contact',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _showEditContactDialog(context, user);
                    },
                    icon: const Icon(Icons.edit))
              ]),
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

void _showEditNameDialog(BuildContext context, UserSchema user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: TextEditingController(text: user.name),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 10, // Allows the TextField to expand vertically
          decoration: const InputDecoration(
            hintText: 'Enter your new name...',
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

void _showEditPersonalDetailsDialog(BuildContext context, UserSchema user) {
  // Define initial values for dateOfBirth and gender
  DateTime initialDateOfBirth = user.dateOfBirth ?? DateTime.now();
  String initialGender = user.gender ?? '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Define variables to hold the current values of dateOfBirth and gender
      DateTime selectedDateOfBirth = initialDateOfBirth;
      String selectedGender = initialGender;

      return AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                initialValue: selectedDateOfBirth.toString(), // Set initial value
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Gender'),
                initialValue: selectedGender, // Set initial value
                onChanged: (value) {
                  // Update selectedGender when input changes
                  selectedGender = value;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Add functionality to save changes
              // You can access selectedDateOfBirth and selectedGender here
              // and perform necessary actions like updating the user profile
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              // Add functionality to close dialog without saving changes
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _showEditContactDialog(BuildContext context, UserSchema user) {
  // Define a TextEditingController to manage the phone number input
  TextEditingController phoneNumberController =
  TextEditingController(text: user.phone);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Phone Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Validate the phone number before saving
              String enteredPhoneNumber =
              phoneNumberController.text.trim();
              if (isValidPhoneNumber(enteredPhoneNumber)) {
                // Perform necessary actions with the valid phone number
                // For example, update the user's profile
                // user.phoneNumber = enteredPhoneNumber;
                Navigator.of(context).pop();
              } else {
                // Show an error message for invalid phone number
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Invalid phone number'),
                  ),
                );
              }
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