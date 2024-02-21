import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

import 'package:mobile/api.dart';

typedef OnSaveHandler = void Function(Function closeDialog, String name,String email, String phone, String gender,String description);

enum Gender { male, female }

class EditDetails extends StatefulWidget {
  static void open(BuildContext context, UserSchema user, OnSaveHandler onSave) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return EditDetails(user, () {
          Navigator.of(context).pop(dialogContext);
        }, onSave);
      },
    );
  }

  final UserSchema user;
  final Function onClose;
  final OnSaveHandler onSave;

  const EditDetails(this.user, this.onClose, this.onSave, {super.key});

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  Gender? gender;
  late TextEditingController descriptionController;
  late DateTime selectedDateOfBirth;



  @override
  void initState(){
    super.initState();

    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    gender = (widget.user.gender == "male") ? Gender.male : Gender.female;
    descriptionController = TextEditingController(text: widget.user.description);

  }

  void saveOnPressed () {
    String genderAsText = (gender ==  Gender.male) ? "male" : "female";

    widget.onSave(widget.onClose, nameController.text, emailController.text, phoneController.text, genderAsText, descriptionController.text);

  }

  void cancelOnPressed() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
  return AlertDialog(
    title: const Text('Edit Details'),
    content:Container(
      child: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
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
        if(widget.user.isCoach)
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.text,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Description',
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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: const Icon(Icons.boy),
                leading: Radio<Gender>(
                  value: Gender.male,
                  groupValue: gender,
                  onChanged: (Gender? value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Icon(Icons.girl),
                leading: Radio<Gender>(
                  value: Gender.female,
                  groupValue: gender,
                  onChanged: (Gender? value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  )),
    ),
    actions: <Widget>[
      TextButton(
        onPressed: saveOnPressed,
        child: const Text('Save'),
      ),
      TextButton(
        onPressed: cancelOnPressed,
        child: const Text('Cancel'),
      ),
    ],
  );
  }
}
