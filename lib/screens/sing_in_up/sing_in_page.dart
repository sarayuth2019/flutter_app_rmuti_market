import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/main.dart';
import 'package:flutter_app_rmuti_market/screens/admin/adminMainPage.dart';
import 'package:flutter_app_rmuti_market/screens/sing_in_up/sing_up_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  final urlSingIn = "${Config.API_URL}/authorizeMarket";

  //int? accountID;
  var token;
  var marketID;
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.teal,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingUp()));
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
                  "PowerGroup Market",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
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
                  child: Text('เข้าสู่ระบบ'),
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSingIn() {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnSingIn);
    Map params = Map();
    params['email'] = email.text;
    params['password'] = password.text;
    print(email.text);
    print(password.text);
    http.post(Uri.parse(urlSingIn), body: params).then((res) {
      print(res.body);
      Map resData = jsonDecode(res.body) as Map;
      var _resStatus = resData['data'];
      var _resToken = resData['token'];
      var _resCustomerID = resData['marketId'];
      var _resStatusMarket = resData['statusMarket'];

      setState(() {
        if (_resStatus == 1) {
          print('status market : ${_resStatusMarket.toString()}');
          token = _resToken;
          marketID = _resCustomerID;
          if (_resStatusMarket == "market") {
            saveUserIDToDevice(token, marketID, _resStatusMarket);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(token!, marketID!)),
                (route) => false);
          } else if (_resStatusMarket == "admin") {
            saveUserIDToDevice(token, marketID, _resStatusMarket);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminMainPage(token!, marketID!)),
                (route) => false);
          }
        } else if (_resStatus == 0) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarSingInFail);
        }
      });
    });
  }

  Future saveUserIDToDevice(
      String token, int marketId, String statusMarket) async {
    final SharedPreferences _dataID = await SharedPreferences.getInstance();
    _dataID.setString('tokenIDInDevice', token);
    _dataID.setInt('marketIDInDevice', marketId);
    _dataID.setString('statusMarket', statusMarket);
    print("save accountID to device : aid ${_dataID.toString()}");
  }

  Future autoLogin() async {
    final SharedPreferences _dataID = await SharedPreferences.getInstance();
    final _tokenIDInDevice = _dataID.getString('tokenIDInDevice');
    final _userIDInDevice = _dataID.getInt('marketIDInDevice');
    final _statusMarketInDevice = _dataID.getString('statusMarket');
    if (_tokenIDInDevice != null) {
      if (_statusMarketInDevice == 'market') {
        setState(() {
          token = _tokenIDInDevice;
          print("account login future: token ${token.toString()}");
          marketID = _userIDInDevice;
          print("account login future: CustomerID ${token.toString()}");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(token!, marketID!)),
              (route) => false);
        });
      } else if (_statusMarketInDevice == 'admin') {
        setState(() {
          token = _tokenIDInDevice;
          print("account login future: token ${token.toString()}");
          marketID = _userIDInDevice;
          print("account login future: CustomerID ${token.toString()}");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminMainPage(token!, marketID!)),
              (route) => false);
        });
      }
    } else {
      print("No user login");
    }
  }
}
