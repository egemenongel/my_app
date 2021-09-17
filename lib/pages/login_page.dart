import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:internative_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.globalToken}) : super(key: key);
  var globalToken = "token";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var _errorMessage;
  bool _passwordVisible = false;

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token") ?? "token";
    return token;
  }

  Future<void> login() async {
    var jsonResponse;
    var data = {
      "Email": _emailController.text,
      "Password": _passwordController.text,
    };

    var headers = {
      "Content-Type": "application/json",
    };

    setToken() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("token", jsonResponse["Data"]["Token"]);
    }

    final response = await http.post(
        Uri.parse("http://test11.internative.net/Login/SignIn"),
        body: jsonEncode(data),
        headers: headers);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      widget.globalToken = await getToken();

      if ("token" == widget.globalToken) {
        setToken();
      } else {
        widget.globalToken = await getToken();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      globalToken: widget.globalToken,
                    )));
      }
    }

    throw Exception("Error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "E-mail",
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.number,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.vpn_key_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_emailController.text == "" &&
                      _passwordController.text == "") {
                    _errorMessage = "Lütfen boş alanları doldurun";
                  } else {
                    _errorMessage = "";
                  }
                  login();
                });
              },
              child: Text("Login"),
            ),
            FutureBuilder(
                future: login(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(_errorMessage ?? "");
                  } else
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());

                      case ConnectionState.done:
                      case ConnectionState.active:
                      case ConnectionState.none:
                        return Text(_errorMessage ?? "");
                    }
                }),
          ],
        ),
      ),
    ));
  }
}
