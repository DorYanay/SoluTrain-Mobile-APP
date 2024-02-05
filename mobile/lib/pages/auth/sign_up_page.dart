import 'package:flutter/material.dart';
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
  Gender? gender;

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

  void signUpOnTap() {
    if (moveToLogin) {
      widget.showLogin();
    }

    // validation
    if (nameController.text == '') {
      setErrorMessage('Name is required!');
      return;
    }

    if (gender == null) {
      setErrorMessage('Gender is required!');
      return;
    }

    setErrorMessage("");

    // send the request
    API.post('/auth/signup', params: {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone': phoneController.text,
      'gender': gender == Gender.male ? "male" : "female",
    }).then((Response res) {
      if (res.hasError) {
        if (res.errorMessage != "") {
          setErrorMessage(res.errorMessage);
        } else {
          setErrorMessage("The sign up failed");
        }
        return;
      }

      setSuccessMessage("You sign up successfully");

      setState(() {
        moveToLogin = true;
      });
    }).onError((error, stackTrace) {
      setErrorMessage("The sign up failed because the network");
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
                const SizedBox(height: 10),

                Image.asset(
                  'lib/images/unlock.png',
                  height: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 10),

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

                const SizedBox(height: 10),

                AppTextField(
                  controller: phoneController,
                  hintText: 'Phone',
                  obscureText: false,
                ),

                const SizedBox(height: 15),

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

                const SizedBox(height: 10),

                Text(
                  userMessage,
                  style: TextStyle(
                    color: userMessageColor,
                  ),
                ),

                const SizedBox(height: 15),

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
