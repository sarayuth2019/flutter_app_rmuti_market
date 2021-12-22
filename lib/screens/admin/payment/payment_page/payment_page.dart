import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/market__data_page/market_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/user_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_tab.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_Image_payment_method.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_by_payId.dart';
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
  final Payment paymentData;
  final String urlGetPayData = '${Config.API_URL}/Pay/listId';
  final String urlSavePay = '${Config.API_URL}/Pay/save';
  final String urlGetItemByItemId = '${Config.API_URL}/Item/list/item';
  final String urlUpdateItem = '${Config.API_URL}/Item/update';

  //_Items? item;
  List listDetail = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*
    getItemByItemId(paymentData.itemId).then((value) {
      item = value!;
      print('Item Data : ${item}');
    });
     */
    List _listDetail = paymentData.detail.substring(1,paymentData.detail.length-1).split(',');

    print('listDetail : ${_listDetail}');
    print('listDetail length : ${_listDetail.length}');
    print('listDetail length data : ${_listDetail[5]}');
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
                    future: getPaymentByPayId(token, paymentData.payId),
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
                                          'จำนวนของสินค้า : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // Text('${snapshot.data.number}'),
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
                                    /*
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
                                              //Text('${item!.count}/${item!.countRequest}'),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    */
                                    Row(
                                      children: [
                                        Text(
                                          'รายละเอียดสินค้า : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        /*
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
                                        */
                                      ],
                                    ),
                                    Container(
                                      height: double.parse(
                                          (listDetail.length * 12)
                                              .toString()),
                                      width: 400,
                                      child: ListView.builder(
                                        itemCount: listDetail.length,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          if (listDetail.length ==
                                              0) {
                                            return Container();
                                          } else {
                                            return Text(
                                                '${listDetail}');
                                          }
                                        },
                                      ),
                                    )
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
                            /*
                            Container(
                                child: item!.count == item!.countRequest
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          color: Colors.orange,
                                          height: 30,
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: Text(
                                                'จำนวนผู้ลงทะเบียนครบแล้ว',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                              //ElevatedButton(onPressed: (){}, child: Text('คืนเงิน'))
                                            ],
                                          ),
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

                             */
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
      //getItemByItemId(paymentData.itemId);
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
          // updateItem(_paymentData, _number, statusPayment);
        } else {
          //updateItem(_paymentData, 0, statusPayment);
        }
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ชำระเงิน ผิดพลาด !')));
      }
    });
  }

  void updateItem(_paymentData, int number, status, itemData) async {
    var _dateBegin =
        '${itemData!.dateBegin.split('/')[1]}/${itemData!.dateBegin.split('/')[0]}/${itemData!.dateBegin.split('/')[2]}';
    var _dateFinal =
        '${itemData!.dateFinal.split('/')[1]}/${itemData!.dateFinal.split('/')[0]}/${itemData!.dateFinal.split('/')[2]}';
    var _dealBegin =
        '${itemData!.dealBegin.split('/')[1]}/${itemData!.dealBegin.split('/')[0]}/${itemData!.dealBegin.split('/')[2]}';
    var _dealFinal =
        '${itemData!.dealFinal.split('/')[1]}/${itemData!.dealFinal.split('/')[0]}/${itemData!.dealFinal.split('/')[2]}';

    String _textListSize = itemData!.size.toString();
    String textListSize = _textListSize.substring(1, _textListSize.length - 1);
    String _textListColor = itemData!.color.toString();
    String textListColor =
        _textListColor.substring(1, _textListColor.length - 1);

    Map params = Map();
    params['itemId'] = itemData!.itemId.toString();
    params['marketId'] = itemData!.marketId.toString();
    params['nameItems'] = itemData!.nameItem.toString();
    params['groupItems'] = itemData!.groupItem.toString();
    params['price'] = itemData!.price.toString();
    params['priceSell'] = itemData!.priceSell.toString();
    params['count'] = (itemData!.count + number).toString();
    params['countRequest'] = itemData!.countRequest.toString();
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

          if (itemData!.countRequest ==
              (itemData!.count + _paymentData.number)) {
            String textNotifyUser =
                'ยืนยันการชำระเงินสำเร็จ ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${itemData!.dateBegin} - ${itemData!.dateFinal}';
            notifyUserMethod(context, token, _paymentData.userId,
                _paymentData.payId, _paymentData.amount, textNotifyUser);

            String textNotifyMarket =
                'ยืนยันการลงทะเบียนสินค้า Item Id : ${itemData!.itemId} ${itemData!.nameItem}';
            int _count = (itemData!.count + _paymentData.number).toInt();
            notifyMarketMethod(
                context,
                token,
                _paymentData.marketId,
                _paymentData.payId,
                _count,
                itemData!.countRequest,
                textNotifyMarket);

            print('Notify All user get item');
            String textStatus =
                'จำนวนผู้ลงทะเบียนครบแล้ว ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${itemData!.dateBegin} - ${itemData!.dateFinal}';
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
                'ยืนยันการชำระเงินสำเร็จ ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${itemData!.dateBegin} - ${itemData!.dateFinal}';
            notifyUserMethod(context, token, _paymentData.userId,
                _paymentData.payId, _paymentData.amount, textNotifyUser);

            String textNotifyMarket =
                'ยืนยันการลงทะเบียนสินค้า Item Id : ${itemData!.itemId} ${itemData!.nameItem}';
            int _count = (itemData!.count + _paymentData.number).toInt();
            notifyMarketMethod(
                context,
                token,
                _paymentData.marketId,
                _paymentData.payId,
                _count,
                itemData!.countRequest,
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
    //item = itemData;
    return itemData;
  }
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

class Detail {
  Detail(this.item, this.size, this.color, this.price, this.number);
  final String item;
  final String size;
  final String color;
  final int price;
  final int number;
}