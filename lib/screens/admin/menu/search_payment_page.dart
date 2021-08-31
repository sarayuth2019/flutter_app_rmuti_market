import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;

class SearchPayment extends StatefulWidget {
  SearchPayment(this.token);

  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPayment(token);
  }
}

class _SearchPayment extends State {
  _SearchPayment(this.token);

  final token;

  _Payment? paymentData;
  TextEditingController paymentSearch = TextEditingController();
  var _jsonData;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'PaymentId'),
              controller: paymentSearch,
            ),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                onPressed: () {
                  if (paymentSearch.text.length != 0) {
                    getPaymentData(token, int.parse(paymentSearch.text));
                  }
                },
                child: Text('ค้นหา'))
          ],
        ),
        body: Container(
            child: _jsonData == null
                ? Container(
                    child: Center(
                        child: Text(
                      'ไม่พบข้อมูล',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    )),
                  )
                : Column(
                    children: [
                      Container(
                          child: paymentData != null
                              ? Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: boxDecorationGrey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Payment Id : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                      'Item Id  ${paymentData!.payId} '),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'ชำระสินค้า : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      'Item Id  ${paymentData!.itemId} '),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'สินค้าของ : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      'Market Id  ${paymentData!.marketId} '),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'ชำระโดย : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      'User Id ${paymentData!.marketId} '),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'ธนาคารที่โอน : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      '${paymentData!.bankTransfer}'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'ธนาคารที่รับ : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      '${paymentData!.bankReceive}'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'จำนวนเงิน : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      '${paymentData!.amount} บาท'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'วันที่โอน : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text('${paymentData!.date}'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'เวลาที่โอน : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text('${paymentData!.time}'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'เลขท้ายบัญชี 4 ตัว : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      '${paymentData!.lastNumber}'),
                                                ],
                                              ),
                                              Center(child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                                                  onPressed: (){
                                                    _showPaymentImage(context, paymentData!.payId);
                                                  }, child: Text('ดูสลีปจ่ายเงิน')))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container()),
                    ],
                  )));
  }

  void _showPaymentImage(BuildContext context, snapShotPaymentId) async {
    print('Show Alert Dialog Image Payment !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Payment Id : ${snapShotPaymentId.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: FutureBuilder(
                future: getImagePay(snapShotPaymentId),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
                      child: Image.memory(base64Decode(snapshot.data)),
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  Future<void> getImagePay(int paymentId) async {
    final String urlGetPayImage = '${Config.API_URL}/ImagePay/listId';
    var imagePay;
    Map params = Map();
    params['payId'] = paymentId.toString();
    await http.post(Uri.parse(urlGetPayImage), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      var imagePayData = jsonData['dataImages'];
      imagePay = imagePayData;
    });
    return imagePay;
  }

  Future<_Payment?> getPaymentData(token, int paymentId) async {
    const String urlGetPaymentData = '${Config.API_URL}/Pay/listId';
    Map params = Map();
    params['id'] = paymentId.toString();
    await http.post(Uri.parse(urlGetPaymentData), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      print(jsonData);
      var payData = jsonData['data'];
      if (payData == null) {
        setState(() {
          _jsonData = payData;
        });
      } else {
        _Payment _payment = _Payment(
            payData['payId'],
            payData['status'],
            payData['userId'],
            payData['marketId'],
            payData['itemId'],
            payData['amount'],
            payData['lastNumber'],
            payData['bankTransfer'],
            payData['bankReceive'],
            payData['date'],
            payData['time'],
            payData['dataTransfer']);
        setState(() {
          _jsonData = payData;
          paymentData = _payment;
        });
      }
    });
    return paymentData;
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
