import 'package:flutter/material.dart';
import 'package:mobile/pages/profile/trainer_profile_page.dart';
import 'package:mobile/pages/profile/coach_profile_page.dart';

void main() {
  runApp(const SoluTrainApp());
}

class SoluTrainApp extends StatelessWidget {
  const SoluTrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoluTrain',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: TrainerProfilePage(),
    );
  }
}
