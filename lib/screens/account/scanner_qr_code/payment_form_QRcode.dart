import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/item_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;

class PaymentFormQRCode extends StatefulWidget {
  PaymentFormQRCode(this.token, this.paymentId);

  final token;
  final int paymentId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentFormQRCode(token, paymentId);
  }
}

class _PaymentFormQRCode extends State {
  _PaymentFormQRCode(this.token, this.paymentId);

  final token;
  final int paymentId;
  final String urlGetPayData = '${Config.API_URL}/Pay/listId';
  final String urlGetPayImage = '${Config.API_URL}/ImagePay/payId';
  final String urlSavePay = '${Config.API_URL}/Pay/save';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FutureBuilder(
        future: getPaymentData(paymentId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'สถานะ ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            child: snapshot.data.status == 'ชำระเงินสำเร็จ'
                                ? Text(
                                    '${snapshot.data.status}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )
                                : Text(
                                    '${snapshot.data.status}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        decoration: boxDecorationGrey,
                        height: 400,
                        width: 250,
                        child: FutureBuilder(
                          future: getImagePayment(paymentId),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshotImage) {
                            if (snapshotImage.data == null) {
                              return Container(
                                  decoration: boxDecorationGrey,
                                  child:
                                      Center(child: Text('กำลังโหลดสลีป...')));
                            } else {
                              return Container(
                                  decoration: boxDecorationGrey,
                                  child: Image.memory(
                                    base64Decode(snapshotImage.data[0]),
                                    fit: BoxFit.fill,
                                  ));
                            }
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: boxDecorationGrey,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ItemDataPage(token,
                                                      snapshot.data.itemId)));
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'ชำระสินค้า : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            'Item Id  ${snapshot.data.itemId} '),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.search,
                                          color: Colors.teal,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'จำนวน : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          '${snapshot.data.number} '),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'สินค้าของ : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          'Market Id  ${snapshot.data.marketId} '),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'ชำระโดย : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          'User Id ${snapshot.data.marketId} '),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'ธนาคารที่โอน : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${snapshot.data.bankTransfer}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'ธนาคารที่รับ : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${snapshot.data.bankReceive}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'จำนวนเงิน : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${snapshot.data.amount} บาท'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'วันที่โอน : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${snapshot.data.date}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'เวลาที่โอน : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${snapshot.data.time}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'เลขท้ายบัญชี 4 ตัว : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${snapshot.data.lastNumber}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: snapshot.data.status == 'ชำระเงินสำเร็จ'
                                  ? Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.teal),
                                          onPressed: () {
                                            _showAlertGetMoney(
                                                context, snapshot.data);
                                          },
                                          child: Text('ส่งมอบสินค้า')),
                                    )
                                  : Container())
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showAlertGetMoney(BuildContext context, _paymentData) async {
    print('Show Alert Dialog !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'ต้องการส่งมอบสินค้าหรือไม่ ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ส่งมอบสินค้า'),
                          onTap: () {
                            _saveStatusPayment(_paymentData);
                            Navigator.pop(context);
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('ยกเลิก'),
                          onTap: () {
                            Navigator.pop(context);
                          })),
                ],
              ),
            ),
          );
        });
  }

  void _saveStatusPayment(_paymentData) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('กำลังดำเนินการ...')));
    String status = 'รับสินค้าสำเร็จ';
    print('save pay ....');
    Map params = Map();
    params['payId'] = _paymentData.payId.toString();
    params['userId'] = _paymentData.userId.toString();
    params['marketId'] = _paymentData.marketId.toString();
    params['number'] = _paymentData.number.toString();
    params['itemId'] = _paymentData.itemId.toString();
    params['bankTransfer'] = _paymentData.bankTransfer.toString();
    params['bankReceive'] = _paymentData.bankReceive.toString();
    params['date'] = _paymentData.date.toString();
    params['time'] = _paymentData.time.toString();
    params['amount'] = _paymentData.amount.toString();
    params['lastNumber'] = _paymentData.lastNumber.toString();
    params['status'] = status.toString();
    await http.post(Uri.parse(urlSavePay), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);
      var resData = jsonDecode(utf8.decode(res.bodyBytes));
      var resStatus = resData['status'];
      if (resStatus == 1) {
        setState(() {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('รับสินค้า สำเร็จ')));
        });
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('รับสินค้า ผิดพลาด !')));
      }
    });
  }

  Future<void> getImagePayment(int payId) async {
    var imagePay;
    Map params = Map();
    params['payId'] = payId.toString();
    await http.post(Uri.parse(urlGetPayImage), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      var imagePayData = jsonData['dataImages'];
      imagePay = imagePayData;
    });
    return imagePay;
  }

  Future<void> getPaymentData(int payId) async {
    var paymentData;
    Map params = Map();
    params['id'] = payId.toString();
    await http.post(Uri.parse(urlGetPayData), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      print(jsonData);
      var _payData = jsonData['data'];
      _Payment _payment = _Payment(
          _payData['payId'],
          _payData['status'],
          _payData['userId'],
          _payData['marketId'],
          _payData['number'],
          _payData['itemId'],
          _payData['amount'],
          _payData['lastNumber'],
          _payData['bankTransfer'],
          _payData['bankReceive'],
          _payData['date'],
          _payData['time'],
          _payData['dataTransfer']);
      paymentData = _payment;
    });
    return paymentData;
  }
}

class _Payment {
  final int payId;
  final String status;
  final int userId;
  final int marketId;
  final int number;
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
      this.number,
      this.itemId,
      this.amount,
      this.lastNumber,
      this.bankTransfer,
      this.bankReceive,
      this.date,
      this.time,
      this.dataTransfer);
}
