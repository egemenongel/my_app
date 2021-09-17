import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:internative_app/pages/home_page.dart';
import 'package:internative_app/pages/users_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.globalToken}) : super(key: key);
  var globalToken;
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    callUser();
  }

  final url = Uri.parse("http://test11.internative.net/Account/Get");

  int? counter;
  var userResult;
  var error;
  var id;

  late var data = userResult["Data"];

  Future callUser() async {
    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer " + widget.globalToken.toString()
      });
      if (response.statusCode == 200) {
        var result = response.body;

        setState(() {
          userResult = jsonDecode(result);
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Profile"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Users"),
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
          Column(
            children: [
              ListTile(
                onTap: () {},
                trailing: Text(
                  data["BirthDate"].toString().substring(0, 10),
                  style: TextStyle(fontSize: 20),
                ),
                title: Text(
                  data["FullName"],
                  style: TextStyle(fontSize: 30),
                ),
                subtitle: Text(
                  data["Email"],
                  style: TextStyle(fontSize: 20),
                ),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                  data["ProfilePhoto"],
                )),
              ),
              SizedBox(
                height: 24,
              ),
            ],
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
