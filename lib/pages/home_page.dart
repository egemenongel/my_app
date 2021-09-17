import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:internative_app/pages/login_page.dart';
import 'package:internative_app/pages/users_page.dart';
import 'package:internative_app/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internative_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.globalToken}) : super(key: key);
  var globalToken;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    callUser();
  }

  final url = Uri.parse("http://test11.internative.net/Account/GetFriendList");

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

          error = result.message;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  removeFromFriends() async {
    var _headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + widget.globalToken.toString(),
    };
    var _body = {"UserId": id.toString()};
    final response = await http.post(Uri.parse(_url + "User/RemoveFromFriends"),
        headers: _headers, body: jsonEncode(_body));
    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UsersPage(
                              globalToken: widget.globalToken,
                            )));
              },
            ),
            ListTile(
              title: Text("My Friends"), //GetFriendList
              onTap: () {
                Navigator.pop(context);
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
                    //Details
                  },
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                    usersList[index].profilePhoto,
                  )),
                  title: Text(usersList[index].fullName),
                  subtitle: Text(usersList[index].email),
                  trailing: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        id = usersList[index].id;

                        usersList.remove(usersList[index]);
                        removeFromFriends();
                      });
                    },
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
