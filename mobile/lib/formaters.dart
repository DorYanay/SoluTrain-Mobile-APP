String dateTimeToAPIString(DateTime dateTime) {
  // Format: "1970-01-10 00:00:00"

  String str = dateTime.year.toString().padLeft(4, '0');
  str += "-${dateTime.month.toString().padLeft(2, '0')}";
  str += "-${dateTime.day.toString().padLeft(2, '0')}";
  str += " ${dateTime.hour.toString().padLeft(2, '0')}";
  str += ":${dateTime.minute.toString().padLeft(2, '0')}";
  str += ":${dateTime.second.toString().padLeft(2, '0')}";

  return str;
}

int calculateAge(DateTime dateOfBirth) {
  DateTime now = DateTime.now();

  int age = now.year - dateOfBirth.year;
  if (dateOfBirth.month < now.month ||
      dateOfBirth.month == now.month && dateOfBirth.day < now.day) {
    age = age--;
  }

  return age;
}
