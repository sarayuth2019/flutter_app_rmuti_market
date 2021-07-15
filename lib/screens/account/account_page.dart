import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/edit_account.dart';
import 'package:flutter_app_rmuti_market/screens/account/sing_in_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  AccountPage(this.token);

  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountPage(token);
  }
}

class _AccountPage extends State {
  _AccountPage(this.token);

  final token;
  final String urlSendAccountById = "${Config.API_URL}/Customer/list/id";
  AccountData? _marketAccountData;

  @override
  Widget build(BuildContext context) {
    print("Market ID : ${token.toString()}");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
                onPressed: logout,
                child: Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditAccount(_marketAccountData)));
          },
        ),
        body: FutureBuilder(
          future: sendAccountDataByUser(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              print('snapshotData : ${snapshot.data}');
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Image.memory(
                        base64Decode(snapshot.data.image),
                        fit: BoxFit.fill,
                      ),
                      color: Colors.blueGrey,
                      height: 270,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Market ID : ${snapshot.data.id}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "ชื่อร้าน : ${snapshot.data.name_store}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "ชื่อเจ้าของร้าน : ${snapshot.data.name} ${snapshot.data.surname}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "อีเมล : ${snapshot.data.email}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "เบอร์ติดต่อ : ${snapshot.data.phone_number}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "รายละเอียดที่อยู่ร้าน : ${snapshot.data.description_store}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }

  Future<AccountData> sendAccountDataByUser() async {
    Map params = Map();
    //params['id'] = accountID.toString();
    await http.post(Uri.parse(urlSendAccountById), body: params).then((res) {
      print("Send Market Data...");
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      print(_jsonRes);
      var _dataAccount = _jsonRes['data'];
      print("data Market : ${_dataAccount.toString()}");
      print(_dataAccount);
      _marketAccountData = AccountData(
          _dataAccount['id'],
          _dataAccount['password'],
          _dataAccount['name'],
          _dataAccount['surname'],
          _dataAccount['email'],
          _dataAccount['phoneNumber'],
          _dataAccount['nameStore'],
          _dataAccount['descriptionStore'],
          _dataAccount['dateRegister'],
          _dataAccount['image']);
      print("market data : ${_marketAccountData}");
    });
    return _marketAccountData!;
  }

  Future logout() async {
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    _accountID.clear();
    print("account logout ! ${_accountID.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
}

class AccountData {
  final int id;
  final String password;
  final String name;
  final String surname;
  final String email;
  final String phone_number;
  final String name_store;
  final String description_store;
  final String dateRegister;
  final String image;

  AccountData(
      this.id,
      this.password,
      this.name,
      this.surname,
      this.email,
      this.phone_number,
      this.name_store,
      this.description_store,
      this.dateRegister,
      this.image);
}
