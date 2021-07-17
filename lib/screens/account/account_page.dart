import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/edit_account.dart';
import 'package:flutter_app_rmuti_market/screens/account/sing_in_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  AccountPage(this.token, this.marketId);

  final token;
  final marketId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountPage(token, marketId);
  }
}

class _AccountPage extends State {
  _AccountPage(this.token, this.marketId);

  final token;
  final marketId;

  final String urlSendAccountById = "${Config.API_URL}/Market/list";
  MarketData? _marketAccountData;

  @override
  Widget build(BuildContext context) {
    print("Market ID : ${marketId.toString()}");
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
              print('Account snapshotData : ${snapshot.data}');
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Image.memory(
                        base64Decode(snapshot.data.imageMarket),
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
                                "Market ID : ${snapshot.data.marketID}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "ชื่อร้าน : ${snapshot.data.nameMarket}",
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
                                "เบอร์ติดต่อ : ${snapshot.data.phoneNumber}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "รายละเอียดที่อยู่ร้าน : ${snapshot.data.descriptionMarket}",
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

  Future<MarketData> sendAccountDataByUser() async {
    await http.post(Uri.parse(urlSendAccountById), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print("Send Market Data...");
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _dataAccount = _jsonRes['data'];
      print(_dataAccount);
      print("data Market : ${_dataAccount.toString()}");
      print(_dataAccount);
      _marketAccountData = MarketData(
        _dataAccount['marketId'],
        _dataAccount['password'],
        _dataAccount['name'],
        _dataAccount['surname'],
        _dataAccount['email'],
        _dataAccount['statusMarket'],
        _dataAccount['imageMarket'],
        _dataAccount['phoneNumber'],
        _dataAccount['nameMarket'],
        _dataAccount['descriptionMarket'],
        _dataAccount['dateRegister'],
      );
      print("market data : ${_marketAccountData}");
    });
    return _marketAccountData!;
  }

  Future logout() async {
    final SharedPreferences _dataID = await SharedPreferences.getInstance();
    _dataID.clear();
    print("account logout ! ${_dataID.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
}

class MarketData {
  final int? marketID;
  final String? password;
  final String? name;
  final String? surname;
  final String? email;
  final String? statusMarket;
  final String? imageMarket;
  final String? phoneNumber;
  final String? nameMarket;
  final String? descriptionMarket;
  final String? dateRegister;

  MarketData(
      this.marketID,
      this.password,
      this.name,
      this.surname,
      this.email,
      this.statusMarket,
      this.imageMarket,
      this.phoneNumber,
      this.nameMarket,
      this.descriptionMarket,
      this.dateRegister);
}
