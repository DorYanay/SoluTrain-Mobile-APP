// This file contains the API Schemas

class User {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String description;
  final bool isCoach;

  User(this.userId, this.name, this.email, this.phone, this.gender, this.description, this.isCoach);

  factory User.fromJson(dynamic data) {
    return User(
      data['user_id'] as String,
      data['name'] as String,
      data['email'] as String,
      data['phone'] as String,
      data['gender'] as String,
      data['description'] as String,
      data['is_coach'] as bool,
    );
  }
}
