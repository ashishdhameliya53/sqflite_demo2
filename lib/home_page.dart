import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite_demo2/add_screen.dart';
import 'package:sqflite_demo2/db_handler.dart';
import 'package:sqflite_demo2/model/student.dart';
import 'package:sqflite_demo2/update_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

bool isfetching = true;
var base64Image;

List<Student> userData = [];
final SlidableController slidableController = SlidableController();
late DB db;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    db = DB.instance;
    setState(() {
      getDatas();
    });
  }

  String sub1 = 'C';
  String sub2 = 'Java';
  String year = 'First Year';
  String status = 'add';
  getDatas() async {
    if (userData != null) {
      userData.clear();
    }
    userData = await db.getAll();
    // print(userData);
    setState(() {
      isfetching = false;
    });
  }

  var isdelete = 0;

  void _deleteItem(Student student) async {
    final result = await _confirmDialog(context);
    if (isdelete == 0) {
      deleteItem(student);
    }
  }

  void deleteItem(Student student) async {
    await db.deleteData(student.name).then((id) {
      // print('delete row id ');
      ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Data Deleted Successfully..')));
      setState(() {
        userData.remove(student);
      });
    });
  }

  _confirmDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Item ?'),
            content: Text('this item delete from your database..'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      isdelete = 1;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('cancel')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isdelete = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Accept')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Student List'),
          actions: [
            IconButton(
                onPressed: () async {
                  setState(() {
                    status = 'add';
                  });
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddScreen(
                        status: status,
                      ),
                    ),
                  );
                  if (result == true) {
                    getDatas();
                    setState(() {});
                  }
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: isfetching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : userData.length == 0
                ? Center(
                    child: Column(
                      children: [
                        Text('no data please click add'),
                        TextButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddScreen(
                                            status: status,
                                          )));
                              if (result == true) {
                                getDatas();
                              }
                            },
                            child: Text('add data'))
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      // Uint8List bytes = userData[index].image. as Uint8List;
                      // dynamic image = userData[index].image;
                      // List<int> imageBytes = userData[index].image.readAsBytesSync();
                      // print(imageBytes);
                      // setState(() {
                      //   base64Image = base64Encode(imageBytes);
                      // });
                      // List<int> list = userData[index].image.codeUnits;
                      // Uint8List base64 = Uint8List.fromList(list);
                

                      
                      //    base64Image = utf8.encode(userData[index].image);
                       
                      // String string = String.fromCharCodes(bytes);

                      return Slidable(
                        actionPane: SlidableStrechActionPane(),
                        controller: slidableController,
                        actions: [
                          IconSlideAction(
                            caption: 'Update',
                            color: Colors.blue,
                            icon: Icons.edit,
                            onTap: () async {
                              setState(() {
                                status = 'update';
                              });
                              Student currentStudent = Student(
                                student_id: userData[index].student_id,
                                roll_no: userData[index].roll_no,
                                name: userData[index].name,
                                email: userData[index].email,
                                mobile: userData[index].mobile,
                                age: userData[index].age,
                                image: userData[index].image,
                                sub1_id: userData[index].sub1_id,
                                sub2_id: userData[index].sub2_id,
                                class_name: userData[index].class_name,
                                sub1_name: userData[index].sub1_name,
                                sub2_name: userData[index].sub2_name,
                                c_id: userData[index].c_id,
                              );
                              print(userData[index].student_id);
                              // db.update(row);
                              final result =
                                  // await Navigator.push(
                                  //      context,
                                  //      MaterialPageRoute(
                                  //          builder: (context) => UpdateScreen(
                                  //                student: currentStudent,
                                  //              ),),
                                  // );
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddScreen(
                                              student: currentStudent,
                                              status: status),
                                          settings: RouteSettings(
                                              arguments: 'update' as String)));
                              if (result == true) {
                                getDatas();
                                setState(() {});
                              }
                              // print(' updated id --> ${userData[index].name}');
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              _deleteItem(userData[index]);
                              print(' deleted id --> ${userData[index].name}');
                            },
                          )
                        ],
                        child: Card(
                          child: ListTile(
                            title: Text(userData[index].name),
                            subtitle:
                                Text(userData[index].class_name.toString()),
                            leading: CircleAvatar(
                              backgroundImage: MemoryImage(base64Decode(userData[index].image)),
                            ),
                            trailing: Text(userData[index].roll_no.toString()),
                          ),
                        ),
                      );
                    }));
  }
}
