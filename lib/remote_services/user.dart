// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

class Student {
  int id;

  String parent_first_name;
  String parent_last_name;
  String first_name;

  String last_name;
  String phone_no;
  String email;
  String gender;
  String birth_date;
  String location;

  String grade;
  String study_purpose;
  String about;

  Student({
    required this.id,
    required this.parent_first_name,
    required this.parent_last_name,
    required this.first_name,
    required this.last_name,
    required this.phone_no,
    required this.email,
    required this.gender,
    required this.birth_date,
    required this.location,
    required this.grade,
    required this.study_purpose,
    required this.about,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json["id"] as int,
      parent_first_name: json["parent_first_name"],
      parent_last_name: json["parent_last_name"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      phone_no: json["phone_no"],
      email: json["email"],
      gender: json["gender"],
      birth_date: json["birth_date"],
      location: json["location"],
      grade: json["grade"],
      study_purpose: json["study_purpose"],
      about: json["about"],
    );
  }
}

class GetLocation {
  int id;

  String name;
  String description;

  GetLocation({
    required this.id,
    required this.name,
    required this.description,
  });

  factory GetLocation.fromJson(Map<String, dynamic> json) {
    return GetLocation(
      id: json["id"] as int,
      name: json["name"],
      description: json["description"],
    );
  }
}

class GetEducationlevel {
  int id;

  String title;
  String description;

  GetEducationlevel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory GetEducationlevel.fromJson(Map<String, dynamic> json) {
    return GetEducationlevel(
      id: json["id"] as int,
      title: json["title"],
      description: json["description"],
    );
  }
}

class GetSubject {
  int id;

  String title;
  String code;

  GetSubject({
    required this.id,
    required this.title,
    required this.code,
  });

  factory GetSubject.fromJson(Map<String, dynamic> json) {
    return GetSubject(
      id: json["id"] as int,
      title: json["title"],
      code: json["code"],
    );
  }
}

class Search {
  int id;
  String user_id;
  String first_name;
  String middle_name;
  String last_name;
  String phone_no;
  String gender;
  String about;
  String subject_id;
  String location_id;

  Search({
    required this.id,
    required this.user_id,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.phone_no,
    required this.gender,
    required this.about,
    required this.subject_id,
    required this.location_id,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
        id: json["id"],
        user_id: json["user_id"],
        first_name: json["first_name"],
        middle_name: json["middle_name"],
        last_name: json["last_name"],
        phone_no: json["phone_no"],
        gender: json["gender"],
        about: json["about"],
        subject_id: json["subject_id"],
        location_id: json["location_id"]);
  }
}
