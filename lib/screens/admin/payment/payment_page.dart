import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/notify_method.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  PaymentPage(this.token, this.paymentData);

  final token;
  final paymentData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentPage(token, paymentData);
  }
}

class _PaymentPage extends State {
  _PaymentPage(this.token, this.paymentData);

  final token;
  final paymentData;
  final String urlGetPayImage = '${Config.API_URL}/ImagePay/listId';
  final String urlGetPayData = '${Config.API_URL}/Pay/listId';
  final String urlSavePay = '${Config.API_URL}/Pay/save';
  final String urlGetItemByItemId = '${Config.API_URL}/Item/list/item';
  final String urlUpdateItem = '${Config.API_URL}/Item/update';

  _Items? item;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemByItemId(paymentData.itemId).then((value) {
      item = value!;
      print('Item Data : ${item}');
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Payment Id : ${paymentData.payId}',
            style: TextStyle(color: Colors.teal),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.teal),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  decoration: boxDecorationGrey,
                  height: 400,
                  width: 250,
                  child: FutureBuilder(
                    future: getImagePayment(paymentData.payId),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshotImage) {
                      if (snapshotImage.data == null) {
                        return Container(
                            decoration: boxDecorationGrey,
                            child: Center(child: Text('กำลังโหลดสลีป...')));
                      } else {
                        return Container(
                            decoration: boxDecorationGrey,
                            child: Image.memory(
                              base64Decode(snapshotImage.data),
                              fit: BoxFit.fill,
                            ));
                      }
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: FutureBuilder(
                    future: getPaymentData(paymentData.payId),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                            child: Center(child: CircularProgressIndicator()));
                      } else {
                        return Column(
                          children: [
                            Container(
                              decoration: boxDecorationGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'ชำระสินค้า : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            'Item Id  ${snapshot.data.itemId} '),
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
                                        Text('  :  '),
                                        Text(
                                          'ราคาสินค้า ${item!.priceSell.toString()} บาท'
                                        ),
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
                                    Row(
                                      children: [
                                        Text(
                                          'จำนวนผู้ลงทะเบียน : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '${item!.count}/${item!.countRequest}'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: item!.count == item!.countRequest
                                    ? Container()
                                    : Center(
                                        child: Container(
                                            child: snapshot.data.status ==
                                                    'รอดำเนินการ'
                                                ? ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.teal),
                                                    onPressed: () {
                                                      _showAlertGetMoney(
                                                          context,
                                                          snapshot.data);
                                                    },
                                                    child:
                                                        Text('ได้รับเงินแล้ว'))
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: Container(
                                                        color: Colors.green,
                                                        height: 30,
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            '${snapshot.data.status}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                      )),
                            Container(
                                child: item!.countRequest == item!.count
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          color: Colors.red,
                                          height: 30,
                                          width: double.infinity,
                                          child: Center(
                                              child: Text(
                                            'จำนวนผู้ลงทะเบียนครบแล้ว',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        ),
                                      )
                                    : Container()),
                          ],
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      getImagePayment(paymentData.payId);
      getItemByItemId(paymentData.itemId);
    });
  }

  void _showAlertGetMoney(BuildContext context, _paymentData) async {
    print('Show Alert Dialog !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'ได้รับเงินถูกต้องตามจำนวน ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ได้รับเงินแล้ว'),
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
    String status = 'ชำระเงินสำเร็จ';
    print('save pay ....');
    Map params = Map();
    params['payId'] = _paymentData.payId.toString();
    params['userId'] = _paymentData.userId.toString();
    params['marketId'] = _paymentData.marketId.toString();
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ได้รับเงินครบตามจำนวน')));
        updateItem(_paymentData);
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ชำระเงิน ผิดพลาด !')));
      }
    });
  }

  void updateItem(_paymentData) async {
    Map params = Map();
    params['itemId'] = item!.itemId.toString();
    params['marketId'] = item!.marketId.toString();
    params['nameItems'] = item!.nameItem.toString();
    params['groupItems'] = item!.groupItem.toString();
    params['price'] = item!.price.toString();
    params['priceSell'] = item!.priceSell.toString();
    params['count'] = (item!.count + 1).toString();
    params['countRequest'] = item!.countRequest.toString();
    params['dateBegin'] = item!.dateBegin.toString();
    params['dateFinal'] = item!.dateFinal.toString();
    params['dealBegin'] = item!.dealBegin.toString();
    params['dealFinal'] = item!.dealFinal.toString();
    http.post(Uri.parse(urlUpdateItem), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      Map _res = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      print(_res);
      var _resStatus = _res['status'];
      setState(() {
        if (_resStatus == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('เพิ่มจำนวนคนไปยัง item นั้นสำเร็จ')));

          String textNotifyUser =
              'ยืนยันการชำระเงินสำเร็จ ใช้สิทธิ์ที่ร้านได้ภายในวันที่ ${item!.dateBegin} - ${item!.dateFinal}';
          notifyUserMethod(context, token, _paymentData.userId,
              _paymentData.payId, _paymentData.amount, textNotifyUser);

          String textNotifyMarket = 'ยืนยันการชำระเงินสำเร็จ จำนวนเงิน ';
          notifyMarketMethod(context, token, _paymentData.marketId,
              _paymentData.payId, _paymentData.amount, textNotifyMarket);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('เพิ่มจำนวนคนไปยัง item นั้นผิดพลาด')));
        }
      });
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

  Future<_Items?> getItemByItemId(int itemId) async {
    _Items? itemData;
    Map params = Map();
    params['id'] = itemId.toString();
    await http.post(Uri.parse(urlGetItemByItemId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print("Get Item By Account Success");
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _itemData = _jsonRes['data'];
      print(_itemData);
      _Items _items = _Items(
        _itemData['itemId'],
        _itemData['nameItems'],
        _itemData['groupItems'],
        _itemData['price'],
        _itemData['priceSell'],
        _itemData['count'],
        _itemData['countRequest'],
        _itemData['marketId'],
        _itemData['dateBegin'],
        _itemData['dateFinal'],
        _itemData['dealBegin'],
        _itemData['dealFinal'],
        _itemData['createDate'],
      );
      itemData = _items;
    });
    return itemData;
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

class _Items {
  final int itemId;
  final String nameItem;
  final int groupItem;
  final int price;
  final int priceSell;
  final int count;
  final int countRequest;
  final int marketId;
  final String dateBegin;
  final String dateFinal;
  final String dealBegin;
  final String dealFinal;
  final String date;

  _Items(
      this.itemId,
      this.nameItem,
      this.groupItem,
      this.price,
      this.priceSell,
      this.count,
      this.countRequest,
      this.marketId,
      this.dateBegin,
      this.dateFinal,
      this.dealBegin,
      this.dealFinal,
      this.date);
}
