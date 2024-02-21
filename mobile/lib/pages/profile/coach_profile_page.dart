import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile/formaters.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:mobile/app_model.dart';

import '../../api.dart';
import 'edit_details.dart';

class CoachProfilePage extends StatefulWidget {
  const CoachProfilePage({super.key});

  @override
  State<CoachProfilePage> createState() => _CoachProfilePage();
}

List<String> certificates = [
  "Certificate 1",
  "Certificate 2",
  "Certificate 3",
  "Certificate 4",
  "Certificate 5",
  "Certificate 6",
  "Certificate 7",
  "Certificate 8",
  "Certificate 9",
  "Certificate 10",
  "Certificate 11",
  "Certificate 12",



]; // Example list of certificates

class _CoachProfilePage extends State<CoachProfilePage> {
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

  void _showCertificateDialog(
      BuildContext context, String certificate, UserSchema user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Certificates'),
              ElevatedButton(
                onPressed: uploadCertificateOnPressed,
                style: ElevatedButton.styleFrom(
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
                    Text(
                      'Add',
                      style: TextStyle(fontSize: 16), // Text style
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Container(
            width: 300, // Set your desired width
            height: 300, // Set your desired height
            child: Scrollbar(
                trackVisibility: true,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
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
                            IconButton(
                              onPressed: () {
                                // Add functionality to download certificate
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )),
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



  void viewGroupsOnPressed() {
    Provider.of<AppModel>(context, listen: false).moveToGroupsPage();
  }

  void editProfileOnPressed() {
    UserSchema user = Provider.of<AppModel>(context, listen: false).user!;

    EditDetails.open(context, user, editProfileDialogOnSave);
  }

  void editProfileDialogOnSave(Function closeDialog, String name,String email, String phone, String gender, String description){
    UserSchema user = Provider.of<AppModel>(context, listen: false).user!;

    Map<String, dynamic> params = {};

    if(name != user.name){
      params["new_name"] = name;
    }

    if(email != user.email){
      params["new_email"] = email;
    }

    if(phone != user.phone){
      params["new_phone"] = phone;
    }

    if(gender != user.gender){
      params["new_gender"] = gender;
    }

    API.post(context, '/profile/update-details', params: params)
        .then((Response res) {
      if (res.hasError) {
        closeDialog();
        return;
      }

      UserSchema updatedUser = UserSchema.fromJson(res.data);

      Provider.of<AppModel>(context, listen: false).setUser(updatedUser);

      closeDialog();
    });
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
    String description = user.description;
    int age = calculateAge(user.dateOfBirth);
    String gender =user.gender;
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
               Center(child: Stack(
                 children: [
                   CircleAvatar(
                     backgroundImage: AssetImage(gender=='male' ? 'lib/images/avatar_man_image.png' : 'lib/images/avatar_woman_image.png'),
                     radius: 80.0,
                   ),
                   Positioned(
                     bottom: 0.0,
                     right: 0.0,
                     child: FloatingActionButton(
                       onPressed: uploadImageOnPressed,
                       mini: true,
                       child: Icon(Icons.camera_alt_rounded),
                     ),
                   ),
                 ],
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
                  IconButton(onPressed: editProfileOnPressed,
                      icon: const Icon(Icons.edit))
                ],
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
                                onPressed: viewGroupsOnPressed,
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

