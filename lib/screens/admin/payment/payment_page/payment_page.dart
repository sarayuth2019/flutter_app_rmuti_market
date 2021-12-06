import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/item_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/market__data_page/market_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/user_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_Image_payment_method.dart';
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
                    future: getImagePayment(token, paymentData.payId),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshotImage) {
                      if (snapshotImage.data == null) {
                        return Container(
                            decoration: boxDecorationGrey,
                            child: Center(child: Text('กำลังโหลดสลีป...')));
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
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 4.0, left: 4.0),
                                  child: Container(
                                    height: 300,
                                    width: 240,
                                    child: Image.memory(
                                      base64Decode(snapshotImage.data[index]),
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
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemDataPage(
                                                        token, item!.itemId)));
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
                                          'จำนวนของสินค้า : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('${snapshot.data.number}'),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MarketDataPage(
                                                        token,
                                                        snapshot
                                                            .data.marketId)));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'สินค้าของ : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              'Market Id  ${snapshot.data.marketId} '),
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
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserDataPage(
                                                        snapshot.data.userId,
                                                        token)));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'ชำระโดย : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              'User Id ${snapshot.data.userId} '),
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
                                          'จำนวนเงินที่โอน : ',
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
                                    FutureBuilder(
                                      future:
                                          getItemByItemId(paymentData.itemId),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.data == null) {
                                          return Row(
                                            children: [
                                              Text(
                                                'จำนวนผู้ลงทะเบียน : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text('.../...'),
                                            ],
                                          );
                                        } else {
                                          return Row(
                                            children: [
                                              Text(
                                                'จำนวนผู้ลงทะเบียน : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  '${item!.count}/${item!.countRequest}'),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'รายละเอียดสินค้า : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                            child: snapshot.data.detail
                                                        .split(',')[0] ==
                                                    'null'
                                                ? Container()
                                                : Text(
                                                    'ขนาด : ${(snapshot.data.detail.split(',')[0]).split(':')[0]}')),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                            child: snapshot.data.detail
                                                        .split(',')[1] ==
                                                    'null'
                                                ? Container()
                                                : Text(
                                                    'สี : ${(snapshot.data.detail.split(',')[1]).split(':')[0]}')),
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
                                child: paymentData.status == 'รอดำเนินการ'
                                    ? Container()
                                    : Container(
                                        child: paymentData.status ==
                                                'ชำระเงินผิดพลาด'
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  color: Colors.red,
                                                  height: 30,
                                                  width: double.infinity,
                                                  child: Center(
                                                      child: Text(
                                                    '${paymentData.status}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  color: Colors.blue,
                                                  height: 30,
                                                  width: double.infinity,
                                                  child: Center(
                                                      child: Text(
                                                    '${paymentData.status}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                ),
                                              ))),
                            SizedBox(height: 10),
                            Container(
                                child: item!.count == item!.countRequest
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          color: Colors.orange,
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
                                    : Center(
                                        child: Container(
                                            child: snapshot.data.status ==
                                                    'รอดำเนินการ'
                                                ? Column(
                                                    children: [
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .teal),
                                                          onPressed: () {
                                                            String
                                                                _statusPayment =
                                                                'ชำระเงินสำเร็จ';
                                                            _showAlertGetMoney(
                                                                context,
                                                                snapshot.data,
                                                                _statusPayment);
                                                          },
                                                          child: Text(
                                                              'ชำระเงินสำเร็จ')),
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .deepOrange),
                                                          onPressed: () {
                                                            String
                                                                _statusPayment =
                                                                'ชำระเงินผิดพลาด';
                                                            _showAlertGetMoney(
                                                                context,
                                                                snapshot.data,
                                                                _statusPayment);
                                                          },
                                                          child: Text(
                                                              'จำนวนเงินผิดพลาด')),
                                                    ],
                                                  )
                                                : Container()),
                                      )),
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
      getImagePayment(token, paymentData.payId);
      getItemByItemId(paymentData.itemId);
    });
  }

  void _showAlertGetMoney(
      BuildContext context, _paymentData, statusPayment) async {
    print('Show Alert Dialog !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '${statusPayment.toString()} ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text(statusPayment),
                          onTap: () {
                            _saveStatusPayment(_paymentData, statusPayment);
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

  void _saveStatusPayment(_paymentData, statusPayment) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('กำลังดำเนินการ...')));
    //String status = 'ชำระเงินสำเร็จ';
    print('save pay ....');
    Map params = Map();
    params['payId'] = _paymentData.payId.toString();
    params['userId'] = _paymentData.userId.toString();
    params['marketId'] = _paymentData.marketId.toString();
    params['number'] = _paymentData.number.toString();
    params['itemId'] = _paymentData.itemId.toString();
    params['detail'] = _paymentData.detail.toString();
    params['bankTransfer'] = _paymentData.bankTransfer.toString();
    params['bankReceive'] = _paymentData.bankReceive.toString();
    params['date'] = _paymentData.date.toString();
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('บันทึกสถานะสำเร็จ')));
        if (statusPayment == 'ชำระเงินสำเร็จ') {
          int _number = _paymentData.number;
          updateItem(_paymentData, _number, statusPayment);
        } else {
          updateItem(_paymentData, 0, statusPayment);
        }
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ชำระเงิน ผิดพลาด !')));
      }
    });
  }

  void updateItem(_paymentData, int number, status) async {
    var _dateBegin =
        '${item!.dateBegin.split('/')[1]}/${item!.dateBegin.split('/')[0]}/${item!.dateBegin.split('/')[2]}';
    var _dateFinal =
        '${item!.dateFinal.split('/')[1]}/${item!.dateFinal.split('/')[0]}/${item!.dateFinal.split('/')[2]}';
    var _dealBegin =
        '${item!.dealBegin.split('/')[1]}/${item!.dealBegin.split('/')[0]}/${item!.dealBegin.split('/')[2]}';
    var _dealFinal =
        '${item!.dealFinal.split('/')[1]}/${item!.dealFinal.split('/')[0]}/${item!.dealFinal.split('/')[2]}';

    String _textListSize = item!.size.toString();
    String textListSize = _textListSize.substring(1, _textListSize.length - 1);
    String _textListColor = item!.color.toString();
    String textListColor =
        _textListColor.substring(1, _textListColor.length - 1);

    Map params = Map();
    params['itemId'] = item!.itemId.toString();
    params['marketId'] = item!.marketId.toString();
    params['nameItems'] = item!.nameItem.toString();
    params['groupItems'] = item!.groupItem.toString();
    params['price'] = item!.price.toString();
    params['priceSell'] = item!.priceSell.toString();
    params['count'] = (item!.count + number).toString();
    params['countRequest'] = item!.countRequest.toString();
    params['dateBegin'] = _dateBegin.toString();
    params['dateFinal'] = _dateFinal.toString();
    params['dealBegin'] = _dealBegin.toString();
    params['dealFinal'] = _dealFinal.toString();
    params['size'] = textListSize.toString();
    params['colors'] = textListColor.toString();
    http.post(Uri.parse(urlUpdateItem), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      Map _res = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      print(_res);
      var _resStatus = _res['status'];
      setState(() {
        if (_resStatus == 1 && status == 'ชำระเงินสำเร็จ') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('เพิ่มจำนวนคนไปยัง item นั้นสำเร็จ')));

          if (item!.countRequest == (item!.count + _paymentData.number)) {
            String textNotifyUser =
                'ยืนยันการชำระเงินสำเร็จ ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${item!.dateBegin} - ${item!.dateFinal}';
            notifyUserMethod(context, token, _paymentData.userId,
                _paymentData.payId, _paymentData.amount, textNotifyUser);

            String textNotifyMarket =
                'ยืนยันการลงทะเบียนสินค้า Item Id : ${item!.itemId} ${item!.nameItem}';
            int _count = (item!.count + _paymentData.number).toInt();
            notifyMarketMethod(
                context,
                token,
                _paymentData.marketId,
                _paymentData.payId,
                _count,
                item!.countRequest,
                textNotifyMarket);

            print('Notify All user get item');
            String textStatus =
                'จำนวนผู้ลงทะเบียนครบแล้ว ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${item!.dateBegin} - ${item!.dateFinal}';
            notifyAllUserMethod(
                context,
                token,
                _paymentData.itemId,
                _paymentData.userId,
                _paymentData.payId,
                _paymentData.amount,
                textStatus);

          } else {
            String textNotifyUser =
                'ยืนยันการชำระเงินสำเร็จ ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${item!.dateBegin} - ${item!.dateFinal}';
            notifyUserMethod(context, token, _paymentData.userId,
                _paymentData.payId, _paymentData.amount, textNotifyUser);

            String textNotifyMarket =
                'ยืนยันการลงทะเบียนสินค้า Item Id : ${item!.itemId} ${item!.nameItem}';
            int _count = (item!.count + _paymentData.number).toInt();
            notifyMarketMethod(
                context,
                token,
                _paymentData.marketId,
                _paymentData.payId,
                _count,
                item!.countRequest,
                textNotifyMarket);
          }
        } else if (_resStatus == 1 && status == 'ชำระเงินผิดพลาด') {
          String textNotifyUser =
              'ยืนยันการชำระเงินผิดพลาด กรุณาตรวจสอบการชำระเงินในหน้า รถเข็น/รอตรวจสอบ';
          notifyUserMethod(context, token, _paymentData.userId,
              _paymentData.payId, _paymentData.amount, textNotifyUser);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('เพิ่มจำนวนคนไปยัง item นั้นผิดพลาด')));
        }
      });
    });
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
      Payment _payment = Payment(
          _payData['payId'],
          _payData['status'],
          _payData['userId'],
          _payData['marketId'],
          _payData['number'],
          _payData['itemId'],
          _payData['detail'],
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
        _itemData['size'],
        _itemData['colors'],
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
    item = itemData;
    return itemData;
  }
}

class Payment {
  final int payId;
  final String status;
  final int userId;
  final int marketId;
  final int number;
  final int itemId;
  final detail;
  final int amount;
  final int lastNumber;
  final String bankTransfer;
  final String bankReceive;
  final String date;
  final String time;
  final String dataTransfer;

  Payment(
      this.payId,
      this.status,
      this.userId,
      this.marketId,
      this.number,
      this.itemId,
      this.detail,
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
  final List size;
  final List color;
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
      this.size,
      this.color,
      this.countRequest,
      this.marketId,
      this.dateBegin,
      this.dateFinal,
      this.dealBegin,
      this.dealFinal,
      this.date);
}
