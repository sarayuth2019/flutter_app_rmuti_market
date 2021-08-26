import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;

class PaymentMainPage extends StatefulWidget {
  PaymentMainPage(this.token);

  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentMainPage(token);
  }
}

class _PaymentMainPage extends State {
  _PaymentMainPage(this.token);

  final token;
  final String urlGetPayment = '${Config.API_URL}/Pay/list';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FutureBuilder(
        future: listPayment(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return Text(
              'ไม่มีรายการการชำระเงิน',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                        decoration: boxDecorationGrey,
                        child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'payId : ${snapshot.data[index].payId}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'ชำระเงินโดย User Id : ${snapshot.data[index].userId}'),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                        'Market Id : ${snapshot.data[index].marketId}')
                                  ],
                                ),
                                Text(
                                    'จำนวน : ${snapshot.data[index].amount} บาท')
                              ],
                            ),
                            subtitle: Container(
                                child: snapshot.data[index].status ==
                                        'รอดำเนินการ'
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.teal),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentPage(
                                                          token,
                                                          snapshot
                                                              .data[index])));
                                        },
                                        child: Text('ตรวจสอบการชำระเงิน'))
                                    : Container(
                                        child: Center(
                                          child: Text(
                                              '${snapshot.data[index].status}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),
                                        ),
                                      )))),
                  );
                });
          }
        },
      ),
    );
  }

  Future<List<_Payment>> listPayment() async {
    List<_Payment> _listPayment = [];
    await http.get(Uri.parse(urlGetPayment), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var resJson = jsonDecode(utf8.decode(res.bodyBytes));
      print(resJson);
      var resData = resJson['data'];
      for (var i in resData) {
        _Payment _payment = _Payment(
            i['payId'],
            i['status'],
            i['userId'],
            i['marketId'],
            i['itemId'],
            i['amount'],
            i['lastNumber'],
            i['bankTransfer'],
            i['bankReceive'],
            i['date'],
            i['time'],
            i['dataTransfer']);
        _listPayment.add(_payment);
      }
    });
    return _listPayment;
  }
}

class _Payment {
  final int payId;
  final String status;
  final int userId;
  final int marketId;
  final int itemId;
  final int amount;
  final int lastNumber;
  final String bankTransfer;
  final String bankReceive;
  final String date;
  final String time;
  final String dataTransfer;

  _Payment(
      this.payId,
      this.status,
      this.userId,
      this.marketId,
      this.itemId,
      this.amount,
      this.lastNumber,
      this.bankTransfer,
      this.bankReceive,
      this.date,
      this.time,
      this.dataTransfer);
}
