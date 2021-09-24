import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_demo2/db_handler.dart';
import 'package:sqflite_demo2/home_page.dart';
import 'package:sqflite_demo2/model/student.dart';

import 'model/class.dart';
import 'model/subject.dart';

class UpdateScreen extends StatefulWidget {
  Student student;
  UpdateScreen({required this.student});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

GlobalKey _key = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();

TextEditingController emailController = TextEditingController();

TextEditingController rollController = TextEditingController();

TextEditingController mobileController = TextEditingController();

TextEditingController ageController = TextEditingController();
late DB db;
var selectedImage;
var selectClass;
var selectSub1;
var selectSub2;
var class_id;
var c_id;
var sub1_id;
var sub2_id;

List<String> sempleClass = [];
List<String> sempleSub1 = [];
List<String> sempleSub2 = [];
List<Class> mClass = [];
List<Subject> mSub = [];

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DB.instance;

    getClassDatas();
    getSub1Datas();
    getSub2Datas();
    // selectedImage = widget.student.image;
    nameController.text = widget.student.name;
    emailController.text = widget.student.email;
    rollController.text = widget.student.roll_no.toString();
    mobileController.text = widget.student.mobile.toString();
    ageController.text = widget.student.age.toString();
    selectClass = widget.student.class_name;
    selectSub1 = widget.student.sub1_name;
    selectSub2 = widget.student.sub2_name;
    c_id = widget.student.c_id;
    sub1_id = widget.student.sub1_id;
    sub2_id = widget.student.sub2_id;

  }

  void updateData(Student student) async {
    print(student.student_id);
    Map<String, dynamic> raw = {
      DB.column_id: student.student_id,
      DB.column_name: student.name,
      DB.column_email: student.email,
      DB.column_roll: student.roll_no,
      DB.column_mobile: student.mobile,
      DB.column_age: student.age,
      // DB.column_image: student.image,
      DB.column_cId: student.c_id,
      DB.column_sub1Id: student.sub1_id,
      DB.column_sub2Id: student.sub2_id,
      // DB.column_className: student.class_name,
      // DB.column_sub1Name: student.sub1_name,
      // DB.column_sub2Name: student.sub2_name,
    };

    await db.update(raw).then((value) {
      print('updated row id $value');

      setState(() {
        // userData.add(student);
      });
    });
    // print(userData[0].name);
  }

  resetSub1Val() {
    for (var i = 0; i < mSub.length; i++) {
      if (selectSub1 == mSub[i].sub_name) {
        setState(() {
          sub1_id = i+1;
        });
      }
    }
  }

  resetSub2Val() {
    for (var i = 0; i < mSub.length; i++) {
      if (selectSub2 == mSub[i].sub_name) {
        setState(() {
          sub2_id = i+1;
        });
      }
    }
  }

  resetClass() {
    for (int i = 0; i < mClass.length; i++) {
      if (selectClass == mClass[i].class_name) {
        setState(() {
          class_id = i+1;
        });
      }
    }
  }

  getClassDatas() async {
    if (mClass != null) {
      mClass.clear();
    }
    mClass = await db.getClass();

    // sempleClass.add('Select Class');

    print(' mClass len -->${mClass.length}');

    for (var i = 0; i < mClass.length; i++) {
      sempleClass.add(mClass[i].class_name);
      // print('mclas_name ==> ${mClass[i].class_name}');
    }

    setState(() {});
  }

  getSub1Datas() async {
    if (mSub != null) {
      mSub.clear();
    }
    mSub = await db.getSubject();

    // sempleSub1.add('Select Subject 1');

    print(' mSub len -->${mSub.length}');

    for (var i = 0; i < mSub.length; i++) {
      sempleSub1.add(mSub[i].sub_name);
      // print('mclas_name ==> ${mClass[i].class_name}');
    }

    setState(() {});
  }

  getSub2Datas() async {
    if (mSub != null) {
      mSub.clear();
    }
    mSub = await db.getSubject();

    // sempleSub2.add('Select Subject 2');

    print(' mSub len -->${mSub.length}');

    for (var i = 0; i < mSub.length; i++) {
      sempleSub2.add(mSub[i].sub_name);
      // print('mclas_name ==> ${mClass[i].class_name}');
    }

    setState(() {});
  }

  _showSub2DropDownMenu() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectSub2.toString(),
      alignment: Alignment.center,
      underline: Container(),
      onChanged: (String? newVal) {
        setState(() {
          selectSub2 = newVal!;
          print(selectClass);
        });
      },
      items: sempleSub2
          .map<DropdownMenuItem<String>>(
            (String val) => DropdownMenuItem(
              value: val,
              child: Text(val),
            ),
          )
          .toList(),
    );
  }

  _showSub1DropDownMenu() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectSub1.toString(),
      alignment: Alignment.center,
      underline: Container(),
      onChanged: (String? newVal) {
        setState(() {
          selectSub1 = newVal!;
          print(selectClass);
        });
      },
      items: sempleSub1
          .map<DropdownMenuItem<String>>(
            (String val) => DropdownMenuItem(
              value: val,
              child: Text(val),
            ),
          )
          .toList(),
    );
  }

  _showClassDropDownMenu() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectClass.toString(),
      alignment: Alignment.center,
      underline: Container(),
      onChanged: (String? newVal) {
        setState(() {
          selectClass = newVal!;
          print(selectClass);
        });
      },
      items: sempleClass
          .map<DropdownMenuItem<String>>(
            (String val) => DropdownMenuItem(
              value: val,
              child: Text(val),
            ),
          )
          .toList(),
    );
  }

  Future _takePhoto(ImageSource source, BuildContext context) async {
    final imageFile = await ImagePicker.platform.pickImage(source: source);

    if (imageFile != null) {
      setState(() {
        selectedImage = File(imageFile.path);
      });
    }
    print('imagePath --> $selectedImage');
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedImage == null
                    ? GestureDetector(
                        onTap: () {
                          _takePhoto(ImageSource.camera, context);
                        },
                        child: Container(
                          height: 150,
                          // width: 200,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )
                    : Container(
                        height: 150,
                        // width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(selectedImage),
                              fit: BoxFit.cover),
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(label: Text('Student Name')),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(label: Text('Student Email')),
                ),
                TextFormField(
                  controller: rollController,
                  decoration: InputDecoration(label: Text('Roll Number')),
                ),
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(label: Text('Mobile Number')),
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(label: Text('Age')),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  height: size.height * 0.055,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: _showClassDropDownMenu(),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  height: size.height * 0.055,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: _showSub1DropDownMenu(),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  height: size.height * 0.055,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: _showSub2DropDownMenu(),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      resetClass();
                      resetSub1Val();
                      resetSub2Val();
                      Student updateRecord = Student(
                        student_id: widget.student.student_id,
                        roll_no: int.parse(rollController.text),
                        name: nameController.text,
                        email: emailController.text,
                        mobile: int.parse(mobileController.text),
                        image: selectedImage,
                        age: int.parse(ageController.text),
                        class_name: selectClass,
                        sub1_name: selectSub1,
                        sub2_name: selectSub2,
                        sub1_id: sub1_id,
                        sub2_id: sub2_id,
                        c_id: c_id,
                        // image: selectedImage,
                      );

                      updateData(updateRecord);
                      // db.updateData(updateRecord);
                      Navigator.pop(context,true);
                    },
                    child: Text('Update'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
