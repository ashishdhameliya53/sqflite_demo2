import 'package:flutter/material.dart';
import 'package:sqflite_demo2/add_screen.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      // routes: {
      //   // AddScreen.routeName : (context) => AddScreen(),
      // },
      home:  HomePage(),
    );
  }
}
