// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:internative_app/pages/home_page.dart';
// import 'package:internative_app/pages/users_page.dart';
// import 'package:internative_app/pages/profile_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:internative_app/models/user_model.dart';
// import 'package:http/http.dart' as http;

// class UserDetailPage extends StatefulWidget {
//   UserDetailPage({Key? key, required this.globalToken, this.userResult})
//       : super(key: key);
//   var globalToken = "token";
//   var userResult;
//   @override
//   _UserDetailPage createState() => _UserDetailPage();
// }

// class _UserDetailPage extends State<UserDetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     late var u = jsonDecode(widget.userResult).data;
//     return Scaffold(
//       body: Text(u.toString()),
//     );
//   }
// }
