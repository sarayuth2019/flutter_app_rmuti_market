// @dart=2.9

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/main.dart';
import 'package:flutter_app_rmuti_market/screens/account/sing_up_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SingIn()));

class SingIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SingIn();
  }
}

class _SingIn extends State {
  final snackBarOnSingIn =
      SnackBar(content: Text("กำลังเข้าสู้ระบบ กรุณารอซักครู่..."));
  final snackBarSingInFail =
      SnackBar(content: Text("กรุณาตรวจสอบ Email หรือ Password"));
  final urlSingIn = "${Config.API_URL}/Customer/Login";

  int accountID;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text("Sing IN"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.orange[600],
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.location_searching,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SingUp()));
                      },
                      child: Center(
                        child: Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                "RMUTI Market",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Card(
                child: ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: TextField(
                controller: email,
                decoration: InputDecoration(
                    hintText: "Email", border: InputBorder.none),
              ),
            )),
            Card(
                child: ListTile(
              leading: Icon(Icons.vpn_key_outlined),
              title: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password", border: InputBorder.none),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: onSingIn,
                child: Text('Sing in'),
                style: ElevatedButton.styleFrom(primary: Colors.orange[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSingIn() {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnSingIn);
    Map params = Map();
    params['email'] = email.text;
    params['password'] = password.text;
    http.post(urlSingIn, body: params).then((res) {
      Map resData = jsonDecode(res.body) as Map;
      var _resStatus = resData['status'];
      var _accountData = resData['data'];
      setState(() {
        if (_resStatus == 1) {
          accountID = _accountData['id'];
          print("Account ID : ${accountID}");
          saveUserIDToDevice();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage(accountID)),
              (route) => false);
        } else if (_resStatus == 0) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarSingInFail);
        }
      });
    });
  }

  Future saveUserIDToDevice() async {
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    _accountID.setInt('accountID', accountID);
    print("save accountID to device : aid ${_accountID.toString()}");
  }

  Future autoLogin() async {
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    final accountIDInDevice = _accountID.getInt('accountID');
    if (accountIDInDevice != null) {
      setState(() {
        accountID = accountIDInDevice;
        print("account login future: accountID ${accountID.toString()}");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage(accountID)),
            (route) => false);
      });
    } else {
      print("No user login");
    }
  }
}
