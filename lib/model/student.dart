import 'dart:io';

class Student {
  int? student_id;
  int roll_no;
  String name;
  String email;
  int mobile;
  String image;
  int age;
  int? c_id;
  int? sub1_id;
  int? sub2_id;
  String? class_name;
  String? sub1_name;
  String? sub2_name;

  Student(
      {this.student_id,
      required this.roll_no,
      required this.name,
      required this.email,
      required this.mobile,
      required this.age,
      required this.image,
       this.class_name,
       this.sub1_name,
       this.sub2_name,
      this.c_id,
      this.sub1_id,
      this.sub2_id});

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        student_id: json['student_id'],
        roll_no: json['roll_no'],
        name: json['name'],
        email: json['email'],
        mobile: json['mobile'],
        age: json['age'],
        image: json['image'],
        class_name: json['class_name'],
        sub1_name: json['sub1_name'],
        sub2_name: json['sub2_name'],
        c_id: json['c_id'],
        sub1_id: json['sub1_id'],
        sub2_id: json['sub2_id'],
      );

  Map<String, dynamic> toMap() => {
        'student_id': student_id,
        'roll_no': roll_no,
        'name': name,
        'email': email,
        'mobile': mobile,
        'age': age,
        'image':image,
        'c_id': c_id,
        'class_name':class_name,
        'sub1_name':sub1_name,
        'sub2_name':sub2_name,
        'sub1_id': sub1_id,
        'sub2_id': sub2_id,
      };
}
