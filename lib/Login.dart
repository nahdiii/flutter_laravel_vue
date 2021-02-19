// import 'dart:js';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_laravel_vue/Api/api.dart';
import 'package:flutter_laravel_vue/Beranda/Home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                // TextField(
                //   controller: email,
                //   decoration: InputDecoration(
                //       hintText: "Email / No Hp ",
                //       hintStyle: TextStyle(color: Colors.grey),
                //       border: InputBorder.none),
                // ),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      this._postLogin();

                      // String varemail = email.text;
                      // String varpassword = password.text;

                      // if (varemail == "nahdi@umbjm.ac.id" &&
                      //     varpassword == "nahdi") {
                      //   showDialog(
                      //       context: context,
                      //       child: AlertDialog(
                      //         title: Text("Login"),
                      //         content: Text("Login Sukses"),
                      //         actions: <Widget>[
                      //           FlatButton(
                      //               onPressed: () {
                      //                 Navigator.pop(context);
                      //               },
                      //               child: Text("OK"))
                      //         ],
                      //       ));
                      // }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _postLogin() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Alert(
              context: context,
              title: "Email atau Password Masih Kosong",
              type: AlertType.error)
          .show();
      return;
    }

    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(message: "Loading...");
    progressDialog.show();

    // Untuk Android
    // var url = 'http://192.168.100.8:8000/api/login-api/';
    // var url = 'http://laravel-vue-flutter.test/api/login-api/';
    // final response = await http.post(url,
    //     body: {'email': email.text, 'password': password.text},
    //     headers: {'Accept': 'application/json'});

    var data = {
      'email': email.text,
      'password': password.text,
    };
    var response = await CallApi().postData(data, 'login-api');
    var body = json.decode(response.body);

    progressDialog.hide();
    // print(body);
    if (response.statusCode == 200) {
      // Alert(context: context, title: "Login Sukses", type: AlertType.success)
      //     .show();
      // print(body["token"]);
      // print(url + '?token=' + json.encode(body["token"]));
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      // var userJson = localStorage.getString('user');
      // var user = json.decode(userJson);
      // print(user['id']);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Alert(context: context, title: "Login Gagal", type: AlertType.error)
          .show();
    }
  }
}
