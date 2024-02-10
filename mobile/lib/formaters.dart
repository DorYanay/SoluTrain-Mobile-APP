int calculateAge(String dateOfBirth) {
  List<String> dobParts = dateOfBirth.split('/');

  int year = int.parse(dobParts[0]);
  int month = int.parse(dobParts[1]);
  int day = int.parse(dobParts[2]);

  DateTime now = DateTime.now();

  int age = now.year - year;
  if (month < now.month || month == now.month && day < now.day) {
    age = age--;
  }

  return age;
}
