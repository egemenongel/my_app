import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:internative_app/pages/home_page.dart';
import 'package:internative_app/pages/login_page.dart';
import 'package:internative_app/pages/user_detail_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(
          globalToken: "token",
        ));
  }
}
