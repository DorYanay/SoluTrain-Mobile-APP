import 'package:flutter/material.dart';
import 'package:mobile/formaters.dart';
import 'package:mobile/widgets/app_button.dart';
import 'package:mobile/widgets/app_textfield.dart';
import 'package:mobile/api.dart';

enum Gender { male, female }

class SighUpPage extends StatefulWidget {
  final void Function() showLogin;

  const SighUpPage({super.key, required this.showLogin});

  @override
  State<SighUpPage> createState() => _SighUpPageState();
}

class _SighUpPageState extends State<SighUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  Gender? gender;

  bool waitForRequest = false;

  String userMessage = "";
  Color userMessageColor = Colors.green;
  bool moveToLogin = false;

  void setErrorMessage(String message) {
    setState(() {
      userMessage = message;
      userMessageColor = Colors.red;
    });
  }

  void setSuccessMessage(String message) {
    setState(() {
      userMessage = message;
      userMessageColor = Colors.green;
    });
  }

  //check if a string has only numbers
  bool isValidPhoneNumber(String phoneNumber) {
    // Check if the phone number contains only digits or starts with "+"
    if (!_containsOnlyDigits(phoneNumber.replaceAll('+', '')) &&
        !phoneNumber.startsWith('+')) {
      return false;
    }

    // Check if the phone number has the correct length
    if (phoneNumber.length < 10 || phoneNumber.length > 14) {
      return false;
    }

    // If all checks pass, the phone number is valid
    return true;
  }

//PHONE VALIDATION
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

  //EMAIL VALIDATION
  bool isValidEmail(String email) {
    if (email.isEmpty) {
      return false; // Email cannot be null or empty
    }

    // Check if "@" symbol exists and is not the first or last character
    if (!email.contains('@') || email.startsWith('@') || email.endsWith('@')) {
      return false;
    }

    // Check if "." symbol exists and is not the first or last character after "@"
    int dotIndex = email.indexOf('.', email.indexOf('@'));
    if (dotIndex == -1 ||
        dotIndex == email.indexOf('@') + 1 ||
        dotIndex == email.length - 1) {
      return false;
    }

    return true;
  }

  //Date of birth Validation
  bool isValidDateOfBirth(String day, String month, String year) {
    // Check if any of the input strings are empty
    if (day.isEmpty || month.isEmpty || year.isEmpty) {
      return false;
    }

    // Parse day, month, and year as integers
    int dayInt = int.tryParse(day) ?? 0;
    int monthInt = int.tryParse(month) ?? 0;
    int yearInt = int.tryParse(year) ?? 0;

    // Check if day, month, and year are within valid ranges
    if (dayInt < 1 ||
        dayInt > 31 ||
        monthInt < 1 ||
        monthInt > 12 ||
        yearInt < 1900 ||
        yearInt > DateTime.now().year) {
      return false;
    }

    // Check if the day is valid for the given month and year
    if (dayInt > 30 &&
        (monthInt == 4 || monthInt == 6 || monthInt == 9 || monthInt == 11)) {
      return false;
    } else if (dayInt > 29 && monthInt == 2) {
      // Check for February in a leap year
      if (yearInt % 4 == 0 && (yearInt % 100 != 0 || yearInt % 400 == 0)) {
        return false; // Leap year, February can have 29 days
      } else {
        return false; // Not a leap year, February can have at most 28 days
      }
    }

    // Date of birth is valid
    return true;
  }

  void signUpOnTap() {
    if (moveToLogin) {
      widget.showLogin();
      return;
    }

    if (waitForRequest) {
      return;
    }

    // validation
    // Check if passwords are not empty and if they match
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setErrorMessage('One or both passwords are empty');
      return;
    }

    if (!(passwordController.text == confirmPasswordController.text)) {
      // Either one or both passwords are empty, or they don't match
      // You should handle this case accordingly
      setErrorMessage('Passwords do not match');
      return;
    }
    if (phoneController.text.isEmpty) {
      setErrorMessage('Phone field is empty');
      return;
    }
    if (nameController.text.isEmpty) {
      setErrorMessage('Name field is empty');
      return;
    }
    if (emailController.text.isEmpty) {
      setErrorMessage('Email field is empty');
      return;
    }
    if (nameController.text == '') {
      setErrorMessage('Name is required!');
      return;
    }
    if (!isValidPhoneNumber(phoneController.text)) {
      setErrorMessage('Use only positive numbers in phone field.');
      return;
    }
    if (!isValidEmail(emailController.text)) {
      setErrorMessage('Invalid Email address.');
      return;
    }
    if (gender == null) {
      setErrorMessage('Gender is required!');
      return;
    }
    if (!isValidDateOfBirth(
        dayController.text, monthController.text, yearController.text)) {
      setErrorMessage('Invalid Date of Birth');
      return;
    }

    DateTime dateOfBirth = DateTime(int.parse(yearController.text),
        int.parse(monthController.text), int.parse(dayController.text));

    setErrorMessage("");

    setState(() {
      waitForRequest = true;
    });

    // send the request
    API.guestPost('/auth/signup', params: {
      'name': nameController.text,
      'email': emailController.text.toLowerCase(),
      'password': passwordController.text,
      'phone': phoneController.text,
      'date_of_birth': dateTimeToAPIString(dateOfBirth),
      'gender': gender == Gender.male ? "male" : "female",
    }).then((Response res) {
      if (res.hasError) {
        if (res.errorMessage != "") {
          setErrorMessage(res.errorMessage);
        } else {
          setErrorMessage("The sign up failed");
        }
        setState(() {
          waitForRequest = false;
        });

        return;
      }

      setSuccessMessage("You sign up successfully");

      setState(() {
        waitForRequest = false;
        moveToLogin = true;
      });
    }).onError((error, stackTrace) {
      setErrorMessage("The sign up failed because the network");
      setState(() {
        waitForRequest = false;
      });
    });
  }

  void loginOnTap() {
    widget.showLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                Image.asset(
                  'lib/images/unlock.png',
                  height: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 5),
                Text(
                  'Let\'s create an account for you',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                AppTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Date Of Birth',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set the color to light purple
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: dayController,
                        hintText: 'Day',
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(width: 0),
                    Expanded(
                      child: AppTextField(
                        controller: monthController,
                        hintText: 'Month',
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(width: 0),
                    Expanded(
                      child: AppTextField(
                        controller: yearController,
                        hintText: 'Year',
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                const SizedBox(height: 5),
                AppTextField(
                  controller: phoneController,
                  hintText: 'Phone',
                  obscureText: false,
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 40),
                    Expanded(
                      child: ListTile(
                        title: const Text('Male'),
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
                        title: const Text('Female'),
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
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 0),
                Text(
                  userMessage,
                  style: TextStyle(
                    color: userMessageColor,
                  ),
                ),
                const SizedBox(height: 0),
                AppButton(
                  onTap: signUpOnTap,
                  text: moveToLogin ? "To Login Page" : "Sign Up",
                ),
                const SizedBox(height: 30),
                Builder(
                  builder: (context) {
                    if (moveToLogin) {
                      return const SizedBox(height: 10);
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: loginOnTap,
                          child: const Text(
                            'Login now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
