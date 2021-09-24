import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo2/model/class.dart';
import 'package:sqflite_demo2/model/student.dart';
import 'package:sqflite_demo2/model/subject.dart';

class DB {
  static const DBName = 'clgeDb.db';
  static const DBTableName = 'Student';
  static const DBVersion = 1;
  static const column_name = 'name';
  static const column_id = 'student_id';
  static const column_email = 'email';
  static const column_roll = 'roll_no';
  static const column_age = 'age';
  static const column_image = 'image';
  static const column_mobile = 'mobile';
  static const column_cId = 'c_id';
  static const column_sub1Id = 'sub1_id';
  static const column_sub2Id = 'sub2_id';
  // static const column_sub1Name = 'sub1_name';
  // static const column_sub2Name = 'sub2_name';
  // static const column_className = 'class_name';

  DB._privateConstructor();
  static final DB instance = DB._privateConstructor();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDatabase();
    return _db!;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, DBName);

    if (!(await databaseExists(path))) {
      print('copy database start');

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }

      ByteData data = await rootBundle.load(join("assets/db", DBName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print('opening existing datatbase');
    }
    return await openDatabase(path, version: DBVersion);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(DBTableName, row);
  }

// 'SELECT s.*,s1.sub_name as sub1_name,s2.sub_name as sub2_name , c.class_name FROM student as s INNER JOIN subject as s1 ON s.sub1_id = s1.sub_id INNER JOIN subject as s2 ON  s.sub2_id = s2.sub_id INNER JOIN class as c ON  s.c_id = c.class_id'
  Future<List<Student>> getAll() async {
    Database db = await instance.database;
    // var result = await db.rawQuery('SELECT student.student_id FROM student INNER JOIN class ON student.c_id = class.class_id');
    // var result = await db.rawQuery('SELECT s.*,s1.sub_name as sub1_name,s2.sub_name as sub2_name FROM student as s INNER JOIN subject as s1 ON s.sub1_id = s1.sub_id INNER JOIN subject as s2 ON  s.sub2_id = s2.sub_id');
    var result = await db.rawQuery(
        'SELECT s.*,s1.sub_name as sub1_name,s2.sub_name as sub2_name , c.class_name FROM student as s INNER JOIN subject as s1 ON s.sub1_id = s1.sub_id INNER JOIN subject as s2 ON  s.sub2_id = s2.sub_id INNER JOIN class as c ON  s.c_id = c.class_id');
    return result.map((e) => Student.fromMap(e)).toList();
  }

  Future<List<Class>> getClass() async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT * FROM class');
    // var result = await db.query('class');
    result.forEach((element) {
      print('value of row =>> $element');
    });

    return result.map((e) => Class.fromMap(e)).toList();
  }

  Future<List<Subject>> getSubject() async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT * FROM subject');
    // var result = await db.query('class');
    // result.forEach((element) {
    //   print('value of row =>> $element');
    // });

    return result.map((e) => Subject.fromMap(e)).toList();
  }

  Future<int?> getCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(NAME) FROM $DBTableName'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    final Database db = await instance.database;
    String id = row[column_id].toString();
    print(row);

    return await db
        .update(DBTableName, row, where: '$column_id =?', whereArgs: [id]);
  }


  Future<void> deleteData(String name) async {
    final Database db = await instance.database;
    await db.delete(DBTableName, where: "$column_name=?", whereArgs: [name]);
  }
}
