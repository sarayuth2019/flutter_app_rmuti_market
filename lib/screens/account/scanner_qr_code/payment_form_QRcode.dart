import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/getDetailOrder.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_order_by_orderId.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_all.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_by_payId.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_status_order.dart';
import 'package:http/http.dart' as http;

class PaymentFormQRCode extends StatefulWidget {
  PaymentFormQRCode(this.token, this.paymentId, this.marketId);

  final token;
  final int paymentId;
  final int marketId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentFormQRCode(token, paymentId, marketId);
  }
}

class _PaymentFormQRCode extends State {
  _PaymentFormQRCode(this.token, this.paymentId, this.marketId);

  final token;
  final int paymentId;
  final int marketId;

  final String urlGetPayImage = '${Config.API_URL}/ImagePay/payId';
  final String urlSavePay = '${Config.API_URL}/Pay/save';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FutureBuilder(
        future: getPaymentByPayId(token, paymentId),
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshotPayment) {
          if (snapshotPayment.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SafeArea(
              child: marketId != snapshotPayment.data.marketId
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ไม่สามารถรับสินค้าได้',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Text(
                            '* เนื่องจากร้านค้านี้ไม่ตรงกับร้านค้าที่ท่านได้ลงทะเบียนไว้',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),

                          ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.teal),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('กลับ'))
                        ],
                      ),
                  )
                  : SingleChildScrollView(
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
                                  child: snapshotPayment.data.status ==
                                          'ชำระเงินสำเร็จ'
                                      ? Text(
                                          '${snapshotPayment.data.status}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        )
                                      : Text(
                                          '${snapshotPayment.data.status}',
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
                                        child: Center(
                                            child: Text('กำลังโหลดสลีป...')));
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 310,
                                        width: double.infinity,
                                        child: ListView.builder(
                                          //shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshotImage.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0, left: 4.0),
                                              child: Container(
                                                height: 300,
                                                width: 240,
                                                child: Image.memory(
                                                  base64Decode(snapshotImage
                                                      .data[index]),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'ชำระสินค้า : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                'Order Id  ${snapshotPayment.data.orderId} '),
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
                                                'Market Id  ${snapshotPayment.data.marketId} '),
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
                                                'User Id ${snapshotPayment.data.userId} '),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'ธนาคารที่โอน : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${snapshotPayment.data.bankTransfer}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'ธนาคารที่รับ : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${snapshotPayment.data.bankReceive}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'จำนวนเงิน : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${snapshotPayment.data.amount} บาท'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'วันที่โอน : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${snapshotPayment.data.date}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'เวลาที่โอน : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${snapshotPayment.data.time}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'เลขท้ายบัญชี 4 ตัว : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${snapshotPayment.data.lastNumber}'),
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
                                  decoration: boxDecorationGrey,
                                  child: FutureBuilder(
                                    future: getDetailOrder(
                                        token, snapshotPayment.data.orderId),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic>
                                            snapshotDetailOrder) {
                                      if (snapshotDetailOrder.data == null) {
                                        return Text('กำลังโหลด...');
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'รายละเอียดสินค้า',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: snapshotDetailOrder
                                                      .data.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Row(
                                                      children: [
                                                        Text(
                                                            '${snapshotDetailOrder.data[index].nameItem.split(':')[1]}'),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Container(
                                                          child: snapshotDetailOrder
                                                                      .data[
                                                                          index]
                                                                      .size ==
                                                                  'null'
                                                              ? Container()
                                                              : Text(
                                                                  'ขนาด : ${snapshotDetailOrder.data[index].size.split(':')[0]}'),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Container(
                                                          child: snapshotDetailOrder
                                                                      .data[
                                                                          index]
                                                                      .color ==
                                                                  'null'
                                                              ? Container()
                                                              : Text(
                                                                  'สี : ${snapshotDetailOrder.data[index].color.split(':')[0]}'),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                            'จำนวน : ${snapshotDetailOrder.data[index].number}'),
                                                      ],
                                                    );
                                                  }),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                FutureBuilder(
                                  future: getOrderByOrderId(
                                      token, snapshotPayment.data.orderId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic>
                                          snapshotOrderData) {
                                    if (snapshotOrderData.data == null) {
                                      return Text('กำลังโหลด...');
                                    } else {
                                      return Container(
                                          child: snapshotPayment.data.status ==
                                                      'ชำระเงินสำเร็จ' &&
                                                  marketId ==
                                                      snapshotPayment
                                                          .data.marketId
                                              ? Container(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.teal),
                                                      onPressed: () {
                                                        _showAlertDeliverItem(
                                                            context,
                                                            snapshotPayment
                                                                .data,
                                                            snapshotOrderData
                                                                .data);
                                                      },
                                                      child:
                                                          Text('ส่งมอบสินค้า')),
                                                )
                                              : Container());
                                    }
                                  },
                                )
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

  void _showAlertDeliverItem(
      BuildContext context, _paymentData, Order orderData) async {
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
                            _saveStatusPayment(_paymentData, orderData);
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

  void _saveStatusPayment(Payment _paymentData, Order orderData) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('กำลังดำเนินการ...')));
    String statusPayment = 'รับสินค้าสำเร็จ';
    String _date =
        '${_paymentData.date.split('/')[1]}/${_paymentData.date.split('/')[0]}/${_paymentData.date.split('/')[2]}';
    print('save pay ....');
    Map params = Map();
    params['payId'] = _paymentData.payId.toString();
    params['userId'] = _paymentData.userId.toString();
    params['orderId'] = _paymentData.orderId.toString();
    params['marketId'] = _paymentData.marketId.toString();
    //params['number'] = _paymentData.number.toString();
    //params['itemId'] = _paymentData.itemId.toString();
    //params['detail'] = _paymentData.detail.toString();
    params['bankTransfer'] = _paymentData.bankTransfer.toString();
    params['bankReceive'] = _paymentData.bankReceive.toString();
    params['date'] = _date.toString();
    params['time'] = _paymentData.time.toString();
    params['amount'] = _paymentData.amount.toString();
    params['lastNumber'] = _paymentData.lastNumber.toString();
    params['status'] = statusPayment.toString();
    await http.post(Uri.parse(urlSavePay), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);
      var resData = jsonDecode(utf8.decode(res.bodyBytes));
      var resStatus = resData['status'];
      if (resStatus == 1) {
        setState(() {
          ////////////////SaveStatusOrder//////////////////
          saveStatusOrder(token, orderData, statusPayment);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ส่งมอบสินค้า สำเร็จ')));
        });
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ส่งมอบสินค้า ผิดพลาด !')));
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
}
