import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:internative_app/pages/profile_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:internative_app/models/user_model.dart';
import 'package:internative_app/pages/home_page.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  UsersPage({Key? key, required this.globalToken}) : super(key: key);
  var globalToken;
  var userResult;
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    callUser();
  }

  final url = Uri.parse("http://test11.internative.net/User/GetUsers");

  int? counter;
  var userResult;
  var error;
  var id;
  var _url = "http://test11.internative.net/";
  late List usersList = List.from(userResult.data);

  Future callUser() async {
    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer " + widget.globalToken.toString()
      });
      if (response.statusCode == 200) {
        var result = userModelFromJson(response.body);

        setState(() {
          counter = result.data.length;
          userResult = result;
          widget.userResult = result;
          error = result.message;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> showDetails() async {
  //   var jsonResponse;
  //   var data = {"Id": "612754e8d2016aea00350bc8"};

  //   var headers = {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer " + widget.globalToken.toString(),
  //   };

  //   final response = await http.post(
  //       Uri.parse("http://test11.internative.net/User/GetUserDetails"),
  //       body: jsonEncode(data),
  //       headers: headers);

  //   if (response.statusCode == 200) {
  //     jsonResponse = json.decode(response.body);

  //     if (jsonResponse != null) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => UserDetailPage(
  //                     globalToken: widget.globalToken,
  //                     userResult: widget.userResult,
  //                   )));
  //     }
  //   }

  //   throw Exception("Error");
  // }

  addToFriends() async {
    var _headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + widget.globalToken.toString(),
    };
    var _body = {"UserId": id.toString()};
    final response = await http.post(Uri.parse(_url + "User/AddToFriends"),
        headers: _headers, body: jsonEncode(_body));
    if (response.statusCode == 200) {
      print(response.body);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Profile"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              globalToken: widget.globalToken,
                            )));
              },
            ),
            ListTile(
              title: Text("Users"), //GetUsers
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("My Friends"), //GetFriendList
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              globalToken: widget.globalToken,
                            )));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: usersList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    id = usersList[index].id;
                  },
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                    usersList[index].profilePhoto,
                  )),
                  title: Text(usersList[index].fullName),
                  subtitle: Text(usersList[index].email),
                  trailing: TextButton(
                    onPressed: () {
                      id = usersList[index].id;
                      print(id);
                      addToFriends();
                    },
                    child: Text(
                      "Add Friend",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    setState(() {
                      sharedPreferences.setString("token", "token");
                      Navigator.popUntil(context, (route) => route.isFirst);
                    });
                  },
                  child: Text("Log Out"))
            ],
          ),
          height: 40,
        ),
      ),
    );
  }
}
