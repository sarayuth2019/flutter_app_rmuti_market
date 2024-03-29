import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/payment_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/search_payment/search_payment_tab.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_all.dart';
import 'package:http/http.dart' as http;

class PaymentTab extends StatefulWidget {
  PaymentTab(this.token, this.tabStatus, this.adminId);

  final token;
  final tabStatus;
  final adminId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentTab(token, tabStatus,adminId);
  }
}

class _PaymentTab extends State {
  _PaymentTab(this.token, this.tabStatus, this.adminId);

  final token;
  final tabStatus;
  final adminId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          mini: true,
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SearchPayment(token,adminId)));
          },
        ),
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
                      fontWeight: FontWeight.bold, color: Colors.grey),
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
                                    'PaymentId : ${snapshot.data[index].payId}',
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
                                                        snapshot.data[index],adminId)));
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

  Future<List<Payment>> listPayment() async {
    final String urlGetPaymentByStatusPayment =
        '${Config.API_URL}/Pay/listByStatus';
    List<Payment> _listPayment = [];
    Map params = Map();
    params['status'] = tabStatus.toString();
    await http.post(Uri.parse(urlGetPaymentByStatusPayment),
        body: params,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      var resJson = jsonDecode(utf8.decode(res.bodyBytes));
      //print(resJson);
      var resData = resJson['dataId'];
      for (var i in resData) {
        Payment _payment = Payment(
            i['payId'],
            i['status'],
            i['userId'],
            i['orderId'],
            i['marketId'],
            i['detail'],
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
