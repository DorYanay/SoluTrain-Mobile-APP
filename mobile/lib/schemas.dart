// This file contains the API Schemas

class AreaSchema {
  final String areaId;
  final String name;

  AreaSchema(this.areaId, this.name);

  factory AreaSchema.fromJson(dynamic data) {
    return AreaSchema(
      data['area_id'] as String,
      data['name'] as String,
    );
  }
}

class UserSchema {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String description;
  final bool isCoach;

  UserSchema(this.userId, this.name, this.email, this.phone, this.gender,
      this.description, this.isCoach);

  factory UserSchema.fromJson(dynamic data) {
    return UserSchema(
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

class LoginResponseSchema {
  final String authToken;
  final UserSchema user;
  final List<AreaSchema> areas;

  LoginResponseSchema(this.authToken, this.user, this.areas);

  factory LoginResponseSchema.fromJson(dynamic data) {
    return LoginResponseSchema(
      data['auth_token'] as String,
      UserSchema.fromJson(data['user']),
      (data['areas'] as List<dynamic>)
          .map((area) => AreaSchema.fromJson(area))
          .toList(),
    );
  }
}
