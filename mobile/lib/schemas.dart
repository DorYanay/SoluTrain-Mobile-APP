// This file contains the API Schemas

class UserBaseSchema {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final DateTime dateOfBirth;

  UserBaseSchema(this.userId, this.name, this.email, this.phone, this.gender,
      this.dateOfBirth);

  factory UserBaseSchema.fromJson(dynamic data) {
    return UserBaseSchema(
      data['user_id'] as String,
      data['name'] as String,
      data['email'] as String,
      data['phone'] as String,
      data['gender'] as String,
      DateTime.parse(data['date_of_birth'] as String),
    );
  }
}

class UserSchema {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final DateTime dateOfBirth;
  final String description;
  final bool isCoach;

  UserSchema(this.userId, this.name, this.email, this.phone, this.gender,
      this.dateOfBirth, this.description, this.isCoach);

  factory UserSchema.fromJson(dynamic data) {
    return UserSchema(
      data['user_id'] as String,
      data['name'] as String,
      data['email'] as String,
      data['phone'] as String,
      data['gender'] as String,
      DateTime.parse(data['date_of_birth'] as String),
      data['description'] as String,
      data['is_coach'] as bool,
    );
  }
}

class FileSchema {
  final String fileId;
  final String name;

  FileSchema(this.fileId, this.name);

  factory FileSchema.fromJson(dynamic data) {
    return FileSchema(
      data['file_id'] as String,
      data['name'] as String,
    );
  }
}

class CertificatesSchema {
  final List<FileSchema> certificates;

  CertificatesSchema(this.certificates);

  factory CertificatesSchema.fromJson(dynamic data) {
    return CertificatesSchema(
      (data['certificates'] as List<dynamic>)
          .map((file) => FileSchema.fromJson(file))
          .toList(),
    );
  }
}

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

class GroupSchema {
  final String groupId;
  final String coachId;
  final String coachName;
  final String name;
  final String description;
  final String areaId;

  GroupSchema(this.groupId, this.coachId, this.coachName, this.name,
      this.description, this.areaId);

  factory GroupSchema.fromJson(dynamic data) {
    return GroupSchema(
      data['group_id'] as String,
      data['coach_id'] as String,
      data['coach_name'] as String,
      data['name'] as String,
      data['description'] as String,
      data['area_id'] as String,
    );
  }
}

class GroupInfoSchema {
  final String groupId;
  final String coachName;
  final String name;
  final String areaName;

  GroupInfoSchema(this.groupId, this.coachName, this.name, this.areaName);

  factory GroupInfoSchema.fromJson(dynamic data) {
    return GroupInfoSchema(
      data['group_id'] as String,
      data['coach_name'] as String,
      data['name'] as String,
      data['area_name'] as String,
    );
  }
}

class MeetSchema {
  final String meetId;
  final String groupId;
  final int maxMembers;
  final DateTime meetDate;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String city;
  final String street;
  final List<UserBaseSchema> members;

  MeetSchema(
      this.meetId,
      this.groupId,
      this.maxMembers,
      this.meetDate,
      this.startTime,
      this.endTime,
      this.duration,
      this.city,
      this.street,
      this.members);

  factory MeetSchema.fromJson(dynamic data) {
    return MeetSchema(
      data['meet_id'] as String,
      data['group_id'] as String,
      data['max_members'] as int,
      DateTime.parse(data['meet_date'] as String),
      DateTime.parse(data['start_time'] as String),
      DateTime.parse(data['end_time'] as String),
      data['duration'] as int,
      data['city'] as String,
      data['street'] as String,
      (data['members'] as List<dynamic>)
          .map((member) => UserBaseSchema.fromJson(member))
          .toList(),
    );
  }
}

class MeetInfoSchema {
  final String meetId;
  final String groupId;
  final String groupName;
  final DateTime meetDate;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String city;
  final String street;
  final bool full;
  final bool registered;

  MeetInfoSchema(
      this.meetId,
      this.groupId,
      this.groupName,
      this.meetDate,
      this.startTime,
      this.endTime,
      this.duration,
      this.city,
      this.street,
      this.full,
      this.registered);

  factory MeetInfoSchema.fromJson(dynamic data) {
    return MeetInfoSchema(
      data['meet_id'] as String,
      data['group_id'] as String,
      data['group_name'] as String,
      DateTime.parse(data['meet_date'] as String),
      DateTime.parse(data['start_time'] as String),
      DateTime.parse(data['end_time'] as String),
      data['duration'] as int,
      data['city'] as String,
      data['street'] as String,
      data['full'] as bool,
      data['registered'] as bool,
    );
  }
}

class GroupViewInfoSchema {
  final GroupSchema group;
  final List<MeetInfoSchema> meets;
  final bool registered;

  GroupViewInfoSchema(this.group, this.meets, this.registered);

  factory GroupViewInfoSchema.fromJson(dynamic data) {
    return GroupViewInfoSchema(
      GroupSchema.fromJson(data['group']),
      (data['meets'] as List<dynamic>)
          .map((meet) => MeetInfoSchema.fromJson(meet))
          .toList(),
      (data['registered'] as bool),
    );
  }
}

class GroupFullSchema {
  final GroupSchema group;
  final List<MeetSchema> meets;
  final List<UserBaseSchema> members;

  GroupFullSchema(this.group, this.meets, this.members);

  factory GroupFullSchema.fromJson(dynamic data) {
    return GroupFullSchema(
      GroupSchema.fromJson(data['group']),
      (data['meets'] as List<dynamic>)
          .map((meet) => MeetSchema.fromJson(meet))
          .toList(),
      (data['members'] as List<dynamic>)
          .map((meet) => UserBaseSchema.fromJson(meet))
          .toList(),
    );
  }
}

class MyGroupsSchema {
  final List<GroupInfoSchema> inGroups;
  final List<GroupSchema> coachGroups;

  MyGroupsSchema(this.inGroups, this.coachGroups);

  factory MyGroupsSchema.fromJson(dynamic data) {
    return MyGroupsSchema(
      (data['in_groups'] as List<dynamic>)
          .map((group) => GroupInfoSchema.fromJson(group))
          .toList(),
      (data['coach_groups'] as List<dynamic>)
          .map((group) => GroupSchema.fromJson(group))
          .toList(),
    );
  }
}

class MyMeetsSchema {
  final List<MeetInfoSchema> meets;

  MyMeetsSchema(this.meets);

  factory MyMeetsSchema.fromJson(dynamic data) {
    return MyMeetsSchema(
      (data['meets'] as List<dynamic>)
          .map((meet) => MeetInfoSchema.fromJson(meet))
          .toList(),
    );
  }
}

class ViewCoachSchema {
  final UserBaseSchema coach;
  final List<FileSchema> certificates;

  ViewCoachSchema(this.coach, this.certificates);

  factory ViewCoachSchema.fromJson(dynamic data) {
    return ViewCoachSchema(
      UserBaseSchema.fromJson(data['coach']),
      (data['certificates'] as List<dynamic>)
          .map((file) => FileSchema.fromJson(file))
          .toList(),
    );
  }
}
