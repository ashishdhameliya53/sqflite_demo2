import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_demo2/db_handler.dart';
import 'package:sqflite_demo2/model/subject.dart';

import 'model/class.dart';
import 'model/student.dart';

class AddScreen extends StatefulWidget {
  Student? student;
  String status;
  AddScreen({this.student, required this.status});
  static const routeName = 'add-screen';

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _key = GlobalKey<FormState>();
  List<Student> userData = [];

  DB db = DB.instance;
  var classList = ['First Year', 'Second Year', 'Third Year'];
  String selectClass = 'Select Class';
  String selectSub1 = 'Select Subject 1';
  String selectSub2 = 'Select Subject 2';
  int sub1 = 1;
  int sub2 = 2;
  int classId = 1;
  List<Class> mClass = [];
  List<Subject> mSub = [];
  List<String> sempleClass = [];
  List<String> sempleSub1 = [];
  List<String> sempleSub2 = [];

  var base64Image;
  var selectedImage;
  var errorClassMsg = 'Class not selected! *';
  var errorSub1Msg = 'Subject1 not selected! *';
  var errorSub2Msg = 'Subject2 not selected! *';
  var errorImageMsg = 'Image not selected! *';
  var errorSemSubMsg = 'Subject2 not sem to Subject1! ';

  bool trueVal = true;
  bool afName = false;
  bool afEmail = false;
  bool afRoll = false;
  bool afMobile = false;
  bool afAge = false;
  bool afClass = false;
  bool afSub1 = false;
  bool afSub2 = false;

  FocusNode fName = FocusNode();
  FocusNode fEmail = FocusNode();
  FocusNode fClass = FocusNode();
  FocusNode fRollNum = FocusNode();
  FocusNode fMobile = FocusNode();
  FocusNode fAge = FocusNode();
  FocusNode fsub1 = FocusNode();
  FocusNode fsub2 = FocusNode();

  _snackBar(String message) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void insertData(Student student) async {
    Map<String, dynamic> raw = {
      DB.column_name: student.name,

      DB.column_email: student.email,
      DB.column_roll: student.roll_no,
      DB.column_mobile: student.mobile,
      DB.column_age: student.age,
      DB.column_image: student.image,
      DB.column_cId: student.c_id,
      DB.column_sub1Id: student.sub1_id,
      DB.column_sub2Id: student.sub2_id,
      // DB.column_className:student.class_name,
      // DB.column_sub1Name:student.sub1_name,
      // DB.column_sub2Name:student.sub2_name,
    };

    await db.insert(raw).then((value) {
      print('inserted row id $value');
      _snackBar('Data Added Successfully..');
      setState(() {
        userData.add(student);
      });
    });
    print(userData[0].name);
  }

  resetSub1Val() {
    for (var i = 0; i < mSub.length; i++) {
      if (selectSub1 == mSub[i].sub_name) {
        setState(() {
          sub1 = i + 1;
        });
      }
    }
  }

  resetSub2Val() {
    for (var i = 0; i < mSub.length; i++) {
      if (selectSub2 == mSub[i].sub_name) {
        setState(() {
          sub2 = i + 1;
        });
      }
    }
  }

  resetClass() {
    for (int i = 0; i < mClass.length; i++) {
      if (selectClass == mClass[i].class_name) {
        setState(() {
          classId = i + 1;
        });
      }
    }
  }

  _showClassDropDownMenu() {
    print('classLength => ${mClass.length}');
    return DropdownButtonFormField<String>(
      isExpanded: true,
      focusNode: fClass,
      // autofocus: afClass ? true : false,

      value: widget.status == 'update' ? selectClass.toString() : null,
      alignment: Alignment.center,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Select Class',
          hintStyle: GoogleFonts.acme(
              textStyle: TextStyle(color: Colors.grey, fontSize: 16))),
      onChanged: (String? newVal) {
        setState(() {
          selectClass = newVal!;
        });
      },
      // validator: (val) {
      //   if (val == 'Select Class') {
      //     return 'Class Not selected';
      //   }
      // },
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

  _showSub1DropDownMenu() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      focusNode: fsub1,
      // autofocus: afSub1 ? true : false,

      value: widget.status == 'update' ? selectSub1.toString() : null,
      alignment: Alignment.center,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Select Subject1',
          hintStyle: GoogleFonts.acme(
              textStyle: TextStyle(color: Colors.grey, fontSize: 16))),
      onChanged: (String? newVal) {
        if (newVal == selectSub2) {
          showDialog(
            context: context,
            builder: (context) => _showDialog(errorSemSubMsg),
          );
        } else {
          setState(() {
            selectSub1 = newVal!;
            print(selectClass);
          });
        }
      },
      // validator: (val) {
      //   if (val == 'Select Subject 1') {
      //     return 'Subject1 Not selected';
      //   }
      // },
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

  _showSub2DropDownMenu() {
    return DropdownButtonFormField<String>(
      focusNode: fsub2,
      // autofocus: afSub2 ? true : false,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Select Subject2',
          hintStyle: GoogleFonts.acme(
              textStyle: TextStyle(color: Colors.grey, fontSize: 16))),
      isExpanded: true,

      value: widget.status == 'update' ? selectSub2.toString() : null,
      alignment: Alignment.center,
      // validator: (val) {
      //   if (val == 'Select Subject 2') {
      //     return 'Subject2 Not selected';
      //   }
      // },

      // autovalidateMode: AutovalidateMode.always,

      onChanged: (String? newVal) {
        if (newVal == selectSub1) {
          showDialog(
            context: context,
            builder: (context) => _showDialog(errorSemSubMsg),
          );
        } else {
          setState(() {
            selectSub2 = newVal!;
            // print(selectClass);
          });
        }
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

  @override
  void initState() {
    super.initState();
    widget.status == 'update' ? fetchValue() : null;
    getClassDatas();
    getSub1Datas();
    getSub2Datas();

    // _showClassDropDownMenu();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    rollController.dispose();
    mobileController.dispose();
    ageController.dispose();
    super.dispose();
  }

  getClassDatas() async {
    if (mClass != null) {
      mClass.clear();
    }
    mClass = await db.getClass();

    sempleClass.add('Select Class');

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

    sempleSub1.add('Select Subject 1');

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

    sempleSub2.add('Select Subject 2');

    print(' mSub len -->${mSub.length}');

    for (var i = 0; i < mSub.length; i++) {
      sempleSub2.add(mSub[i].sub_name);

      // print('mclas_name ==> ${mClass[i].class_name}');
    }

    setState(() {});
  }

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController rollController = TextEditingController();

  TextEditingController mobileController = TextEditingController();

  TextEditingController ageController = TextEditingController();
  var fetchImage;
  fetchValue() {
    nameController.text = widget.student!.name;
    emailController.text = widget.student!.email;
    rollController.text = widget.student!.roll_no.toString();
    mobileController.text = widget.student!.mobile.toString();
    ageController.text = widget.student!.age.toString();
    selectClass = widget.student!.class_name.toString();
    selectSub1 = widget.student!.sub1_name.toString();
    selectSub2 = widget.student!.sub2_name.toString();
    sub1 = widget.student!.sub1_id!;
    sub2 = widget.student!.sub2_id!;
    classId = widget.student!.c_id!;
    selectedImage = widget.student!.image;
  }

  Future _takePhoto(ImageSource source, BuildContext context) async {
    final imageFile = await ImagePicker.platform.pickImage(source: source);

    if (imageFile != null) {
      setState(() {
        fetchImage = File(imageFile.path);
      });
    }
    print('imagePath --> $fetchImage');
    setState(() {
      List<int> imageBytes = fetchImage.readAsBytesSync();
      print(imageBytes);
      setState(() {
        selectedImage = base64Encode(imageBytes);
      });
    });
    // Navigator.pop(context);
  }

  void updateData(Student student) async {
    // print(student.student_id);
    Map<String, dynamic> raw = {
      DB.column_id: student.student_id,
      DB.column_name: student.name,
      DB.column_email: student.email,
      DB.column_roll: student.roll_no,
      DB.column_mobile: student.mobile,
      DB.column_age: student.age,
      DB.column_image: student.image,
      DB.column_cId: student.c_id,
      DB.column_sub1Id: student.sub1_id,
      DB.column_sub2Id: student.sub2_id,
      // DB.column_className: student.class_name,
      // DB.column_sub1Name: student.sub1_name,
      // DB.column_sub2Name: student.sub2_name,
    };

    await db.update(raw).then((value) {
      // print('updated row id $value');
      _snackBar('Data Updated Successfully..');

      // setState(() {
      //   userData.add(student);
      // });
    });
    // print(userData[0].name);
  }

  bool _validator() {
    var flag = true;

    if (selectedImage == null) {
      // isValiImage = true;
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Select Image'));
    } else if (nameController.text.isEmpty) {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Enter Name'));
      // afName = true;
      fName.requestFocus();
    } else if (emailController.text.isEmpty) {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Enter Email'));
      fEmail.requestFocus();

      // afEmail = true;
    } else if (!(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text))) {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Enter Valid Email'));
      fEmail.requestFocus();

      // afEmail = true;
    } else if (rollController.text.isEmpty) {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Input RollNumber'));
      // afRoll = true;
      fRollNum.requestFocus();
    } else if (mobileController.text.isEmpty) {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Input MobileNumber'));
      // afMobile = true;
      fMobile.requestFocus();
    } else if (mobileController.text.length != 10) {
      flag = false;
      showDialog(
          context: context,
          builder: (context) =>
              _showDialog('Please Input Valid 10 Digit MobileNumber'));
      // afMobile = true;
      fMobile.requestFocus();
    } else if (ageController.text.isEmpty) {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Input Age'));
      // afAge = true;
      fAge.requestFocus();
    } else if (selectClass == 'Select Class') {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Select Class'));
      // afClass = true;
      fClass.requestFocus();
    } else if (selectSub1 == 'Select Subject 1') {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Select Subject 1'));
      // afSub1 = false;
      fsub1.requestFocus();
    } else if (selectSub2 == 'Select Subject 2') {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Please Select Subject 2'));
      // afSub2 = true;
      fsub2.requestFocus();
    } else if (selectSub1 == selectSub2) {
      flag = false;
      showDialog(
          context: context,
          builder: (context) => _showDialog('Subject 1 And Subject 2 Not Sem'));
      // afSub2 = true;
      fsub2.requestFocus();
    }
    setState(() {});

    return flag;
  }

  _showDialog(String msg) {
    return AlertDialog(
      title: Text('Some Error'),
      content: Text(msg),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          // AppBar(
          //   // leadingWidth: 10,
          //   toolbarHeight: 100,
          //   elevation: 0,
          //   backgroundColor: Colors.amber,
          //   flexibleSpace: Stack(
          //     // fit: StackFit.expand,
          //     children: [
          //       Container(
          //         // height: 120,
          //         padding: EdgeInsets.all(0),
          //         width: MediaQuery.of(context).size.width,
          //         decoration: BoxDecoration(
          //             image: DecorationImage(
          //                 image: AssetImage('assets/images/top_bar.png'),
          //                 fit: BoxFit.cover)),
          //       ),
          //       Positioned(
          //           left: 20,
          //           top: 50,
          //           child: IconButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               icon: Icon(
          //                 Icons.arrow_back_ios,
          //                 color: Colors.white,
          //                 size: 30,
          //               ))),
          //       Positioned(
          //         left: MediaQuery.of(context).size.width / 2.4,
          //         top: 50,
          //         child: Text(
          //           widget.status == 'update' ? 'Update' : 'Add',
          //           textAlign: TextAlign.center,
          //           style: GoogleFonts.acme(
          //               textStyle: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 30)),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          PreferredSize(
        preferredSize: Size.fromHeight(110), // Set this height
        child: Container(
          color: Colors.transparent,
          child: Stack(
            // fit: StackFit.expand,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/top_bar.png'),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                  left: 20,
                  top: 50,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ))),
              Positioned(
                left: MediaQuery.of(context).size.width / 2.4,
                top: 50,
                child: Text(
                  widget.status == 'update' ? 'Update' : 'Add',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.acme(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: SafeArea(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    selectedImage == null
                        ? Stack(
                            children: [
                              Container(
                                height: 150,
                                // width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/user.png'),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              Positioned(
                                  left: 240,
                                  top: 10,
                                  child: showBottomshit(context)),
                            ],
                          )
                        : Stack(
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: MemoryImage(
                                          base64Decode(selectedImage)),
                                      fit: BoxFit.cover),
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Positioned(
                                left: 240,
                                top: 10,
                                child: showBottomshit(context),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Student Name Required! *';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          controller: nameController,
                          focusNode: fName,
                          // autofocus: afName,
                          decoration: InputDecoration(
                              hintText: 'Student Name',
                              hintStyle: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.person)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          focusNode: fEmail,
                          // autofocus: afEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Email Name Required! *';
                            }
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: 'Student Email',
                              hintStyle: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.email)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          focusNode: fRollNum,
                          // autofocus: afRoll ? true : false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.numberWithOptions(),
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp(r'[0-9]'),
                                allow: true),
                          ],
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Roll Number Required! *';
                            }
                          },
                          controller: rollController,
                          decoration: InputDecoration(
                              hintText: 'Roll Number',
                              hintStyle: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.verified_user)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          // autofocus: afMobile ? true : false,
                          focusNode: fMobile,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Mobile Number Required! *';
                            }
                          },
                          controller: mobileController,
                          decoration: InputDecoration(
                              hintText: 'Mobile Number ',
                              hintStyle: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.contact_phone)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          focusNode: fAge,
                          // autofocus: afAge ? true : false,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp(r'[0-9]'),
                                allow: true),
                          ],
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Age Required! *';
                            }
                          },
                          controller: ageController,
                          decoration: InputDecoration(
                              hintText: 'Age',
                              hintStyle: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16)),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.access_time)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _showClassDropDownMenu(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _showSub1DropDownMenu(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _showSub2DropDownMenu(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_validator()) {
                          resetClass();
                          resetSub1Val();
                          resetSub2Val();

                          widget.status != 'update'
                              ? insertData(
                                  Student(
                                    roll_no: int.parse(rollController.text),
                                    name: nameController.text,
                                    email: emailController.text,
                                    mobile: int.parse(mobileController.text),
                                    age: int.parse(ageController.text),
                                    image: selectedImage,
                                    c_id: classId,
                                    sub1_id: sub1,
                                    sub2_id: sub2,
                                  ),
                                )
                              : updateData(
                                  Student(
                                    student_id: widget.student!.student_id,
                                    roll_no: int.parse(rollController.text),
                                    name: nameController.text,
                                    email: emailController.text,
                                    mobile: int.parse(mobileController.text),
                                    age: int.parse(ageController.text),
                                    class_name: selectClass,
                                    sub1_name: selectSub1,
                                    sub2_name: selectSub2,
                                    sub1_id: sub1,
                                    sub2_id: sub2,
                                    c_id: classId,
                                    image: selectedImage,
                                  ),
                                );

                          Navigator.pop(context, true);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              widget.status == 'update'
                                  ? 'Update'.toUpperCase()
                                  : 'Submit'.toUpperCase(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector showBottomshit(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 100,
                color: Colors.transparent,
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _takePhoto(ImageSource.camera, context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/camera.png',
                                width: 60,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _takePhoto(ImageSource.gallery, context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/gallery.png',
                                width: 60,
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              );
            });
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.edit),
      ),
    );
  }
}
