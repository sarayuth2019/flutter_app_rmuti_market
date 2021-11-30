import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/payment_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;

class UserDataPage extends StatefulWidget {
  UserDataPage(this.userID, this.token);

  final userID;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserDataPage(userID, token);
  }
}

class _UserDataPage extends State {
  _UserDataPage(this.userID, this.token);

  final userID;
  final token;
  var imageUser;
  UserData? _userData;
  String _status = 'ประวัติการซื้อ';

  @override
  Widget build(BuildContext context) {
    print("user ID : ${userID.toString()}");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: sendDataUserByUserId(userID),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  print('snapshotData : ${snapshot.data}');
                  return Center(child: CircularProgressIndicator());
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: Colors.teal,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Container(
                              color: Colors.white,
                              height: 60,
                              width: 60,
                              child: snapshot.data.image == "null"
                                  ? Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Colors.grey,
                                    )
                                  : Image.memory(
                                      base64Decode(imageUser),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Account ID : ${snapshot.data.id}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "ชื่อผู้ใช้ : ${snapshot.data.name}  ${snapshot.data.surname}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "อีเมล : ${snapshot.data.email}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "เบอร์ติดต่อ : ${snapshot.data.phoneNumber}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'ประวัติการซื้อ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Expanded(
              child: FutureBuilder(
                future: listPaymentByStatus(token, userID, _status),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data.length == 0) {
                    return Center(
                        child: Text(
                      'ไม่มีประวัติการซื้อ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: boxDecorationGrey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Id : ${snapshot.data[index].payId}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Text('โอนชำระสินค้า : '),
                                      Text(
                                          'item Id ${snapshot.data[index].itemId}'),
                                    ],
                                  ),
                                  Text(
                                      'โอนเงินจำนวน : ${snapshot.data[index].amount} บาท'),
                                  Text(
                                      'โอนจากบัญชี : xxxxxxx ${snapshot.data[index].lastNumber}'),
                                  Text('${snapshot.data[index].bankTransfer}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('สถานะ : '),
                                      Text(
                                        '${snapshot.data[index].status}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  Future<UserData> sendDataUserByUserId(int userId) async {
    print("Send user Data...");
    final String urlSendAccountById = "${Config.API_URL}/User/list/id";
    Map params = Map();
    params['id'] = userId.toString();
    await http.post(Uri.parse(urlSendAccountById), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _dataUser = _jsonRes['dataId'];
      imageUser = _jsonRes['dataImages'];

      print("data User : ${_dataUser.toString()}");
      _userData = UserData(
          _dataUser['userId'],
          _dataUser['password'],
          _dataUser['name'],
          _dataUser['surname'],
          _dataUser['email'],
          _dataUser['phoneNumber'],
          _dataUser['dateRegister'],
          _dataUser['imageUser']);
      print("user data : ${_userData}");
    });
    return _userData!;
  }

  Future<List<Payment>> listPaymentByStatus(
      token, int userId, String status) async {
    final String urlGetPaymentByUserId = '${Config.API_URL}/Pay/user';
    List<Payment> listPayment = [];
    List<Payment> listPaymentWait = [];
    Map params = Map();
    params['userId'] = userId.toString();
    await http.post(Uri.parse(urlGetPaymentByUserId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      print(jsonData);
      var resData = jsonData['data'];
      for (var i in resData) {
        Payment _payment = Payment(
            i['payId'],
            i['status'],
            i['userId'],
            i['marketId'],
            i['number'],
            i['itemId'],
            i['amount'],
            i['lastNumber'],
            i['bankTransfer'],
            i['bankReceive'],
            i['date'],
            i['time'],
            i['dataTransfer']);
        listPayment.add(_payment);
      }
      if (status == 'ประวัติการซื้อ') {
        List<Payment> _listPaymentWait1 = listPayment
            .where((element) => element.status
                .toLowerCase()
                .contains('รับสินค้าสำเร็จ'.toLowerCase()))
            .toList();
        List<Payment> _listPaymentWait2 = listPayment
            .where((element) => element.status
                .toLowerCase()
                .contains('รีวิวสำเร็จ'.toLowerCase()))
            .toList();
        listPaymentWait = _listPaymentWait1 + _listPaymentWait2;
      }
    });
    return listPaymentWait;
  }
}

class UserData {
  final int id;
  final String password;
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;
  final String dateRegister;
  final String? image;

  UserData(this.id, this.password, this.name, this.surname, this.email,
      this.phoneNumber, this.dateRegister, this.image);
}
