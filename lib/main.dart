import 'package:flutter/material.dart';

import 'layout/todo_app/todo_layout.dart';




void main() async
{


  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  MyApp();
  @override
  Widget build(BuildContext context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomeLayout(),

            );
  }
}

