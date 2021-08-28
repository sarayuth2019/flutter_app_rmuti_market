import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;

class PaymentTab extends StatefulWidget {
  PaymentTab(this.token, this.tabStatus);

  final token;
  final tabStatus;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentTab(token, tabStatus);
  }
}

class _PaymentTab extends State {
  _PaymentTab(this.token, this.tabStatus);

  final token;
  final tabStatus;

  final String urlGetPaymentByStatusPayment =
      '${Config.API_URL}/Pay/listByStatus';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        body: FutureBuilder(
          future: listPayment(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'ไม่มีรายการการชำระเงิน',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
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
                                    children: [
                                      Text(
                                          'ชำระเงินโดย User Id : ${snapshot.data[index].userId}'),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      Text(
                                          'Market Id : ${snapshot.data[index].marketId}')
                                    ],
                                  ),
                                  Text(
                                      'จำนวน : ${snapshot.data[index].amount} บาท'),
                                  Text(
                                      'เลขท้ายบัญชี 4 ตัว : ${snapshot.data[index].lastNumber}'),
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Container(
                                      child: snapshot.data[index].status ==
                                              'รอดำเนินการ'
                                          ? Container(
                                              child: Center(
                                                child: Text(
                                                  '${snapshot.data[index].status}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.amber),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              child: Center(
                                                child: Text(
                                                  '${snapshot.data[index].status}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                              ),
                                            )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.teal),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentPage(token,
                                                        snapshot.data[index])));
                                      },
                                      child: Text('ตรวจสอบการชำระเงิน')),
                                ],
                              ))),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      listPayment();
    });
  }

  Future<List<_Payment>> listPayment() async {
    List<_Payment> _listPayment = [];
    Map params = Map();
    params['status'] = tabStatus.toString();
    await http.post(Uri.parse(urlGetPaymentByStatusPayment),
        body: params,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      var resJson = jsonDecode(utf8.decode(res.bodyBytes));
      print(resJson);
      var resData = resJson['dataId'];
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
