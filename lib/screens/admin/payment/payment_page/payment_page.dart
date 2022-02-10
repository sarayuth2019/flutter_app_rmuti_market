import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/item_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/market__data_page/market_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/user_data_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/getDetailOrder.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_Image_payment_method.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_item_by_itemId.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_order_by_orderId.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_all.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_by_payId.dart';
import 'package:flutter_app_rmuti_market/screens/method/notify_method.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_payment_admin.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_status_order.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  PaymentPage(this.token, this.paymentData, this.adminId);

  final token;
  final paymentData;
  final adminId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentPage(token, paymentData, adminId);
  }
}

class _PaymentPage extends State {
  _PaymentPage(this.token, this.paymentData, this.adminId);

  final token;
  final Payment paymentData;
  final adminId;

  final String urlGetPayData = '${Config.API_URL}/Pay/listId';
  final String urlSavePay = '${Config.API_URL}/Pay/save';
  final String urlUpdateItem = '${Config.API_URL}/Item/update';

  @override
  Widget build(BuildContext context) {
    print('AdminId : ${adminId.toString()}');
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
                        AsyncSnapshot<dynamic> snapshotPayment) {
                      if (snapshotPayment.data == null) {
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
                                                    MarketDataPage(
                                                        token,
                                                        snapshotPayment
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
                                              'Market Id  ${snapshotPayment.data.marketId} '),
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
                                                        snapshotPayment
                                                            .data.userId,
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
                                              'User Id ${snapshotPayment.data.userId} '),
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
                                          'จำนวนเงินที่โอน : ',
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
                                        Text('${snapshotPayment.data.date}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'เวลาที่โอน : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('${snapshotPayment.data.time}'),
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
                              height: 8,
                            ),
                            Container(
                              decoration: boxDecorationGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'รายละเอียดสินค้า',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    FutureBuilder(
                                      future: getDetailOrder(
                                          token, paymentData.orderId),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic>
                                              snapshotDetailOrder) {
                                        if (snapshotDetailOrder.data == null) {
                                          return Text('กำลังโหลด...');
                                        } else {
                                          ////////จำนวนสินค้ารวมกัน////////////
                                          int sumNumber = snapshotDetailOrder
                                              .data
                                              .map((Detail detail) =>
                                                  detail.number)
                                              .reduce((a, b) => a + b);
                                          return Column(
                                            children: [
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
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ItemDataPage(
                                                                        token,
                                                                        int.parse(snapshotDetailOrder
                                                                            .data[index]
                                                                            .nameItem
                                                                            .split(':')[0]))));
                                                      },
                                                      child: Row(
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
                                                      ),
                                                    );
                                                  }),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text('รวมเป็นเงิน : '),
                                                    Text(
                                                      '${snapshotDetailOrder.data.map((e) => e.price * e.number).reduce((a, b) => a + b)}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(' บาท')
                                                  ],
                                                ),
                                              ),
                                              FutureBuilder(
                                                future: getItemByItemId(
                                                    token,
                                                    int.parse(
                                                        snapshotDetailOrder
                                                            .data[0].nameItem
                                                            .split(':')[0])),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<dynamic>
                                                        snapshotItemData) {
                                                  if (snapshotItemData.data ==
                                                      null) {
                                                    return Text('กำลังโหลด...');
                                                  } else {
                                                    return Column(
                                                      children: [
                                                        Text(
                                                            'จำนวนผู้ลงทะเบียน : ${snapshotItemData.data.count}/${snapshotItemData.data.countRequest}'),
                                                        Container(
                                                            child: snapshotItemData
                                                                        .data
                                                                        .count ==
                                                                    snapshotItemData
                                                                        .data
                                                                        .countRequest
                                                                ? ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .orange,
                                                                      height:
                                                                          30,
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            'จำนวนผู้ลงทะเบียนครบแล้ว',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                          //ElevatedButton(onPressed: (){}, child: Text('คืนเงิน'))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : FutureBuilder(
                                                                    future: getOrderByOrderId(
                                                                        token,
                                                                        paymentData
                                                                            .orderId),
                                                                    builder: (BuildContext
                                                                            context,
                                                                        AsyncSnapshot<dynamic>
                                                                            snapshotOrder) {
                                                                      if (snapshotOrder
                                                                              .data ==
                                                                          null) {
                                                                        return Text(
                                                                            'กำลังโหลด...');
                                                                      } else {
                                                                        return Center(
                                                                          child: Container(
                                                                              child: snapshotPayment.data.status == 'รอดำเนินการ'
                                                                                  ? Column(
                                                                                      children: [
                                                                                        ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(primary: Colors.teal),
                                                                                            onPressed: () {
                                                                                              String _statusPayment = 'ชำระเงินสำเร็จ';
                                                                                              _showAlertGetMoney(context, snapshotPayment.data, snapshotOrder.data, _statusPayment, snapshotItemData.data, sumNumber);
                                                                                            },
                                                                                            child: Text('ชำระเงินสำเร็จ')),
                                                                                        ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                                                                                            onPressed: () {
                                                                                              String _statusPayment = 'ชำระเงินผิดพลาด';
                                                                                              _showAlertGetMoney(context, snapshotPayment.data, snapshotOrder.data, _statusPayment, snapshotItemData.data, 0);
                                                                                            },
                                                                                            child: Text('จำนวนเงินผิดพลาด')),
                                                                                      ],
                                                                                    )
                                                                                  : Container()),
                                                                        );
                                                                      }
                                                                    },
                                                                  )),
                                                      ],
                                                    );
                                                  }
                                                },
                                              )
                                            ],
                                          );
                                        }
                                      },
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

  void _showAlertGetMoney(BuildContext context, _paymentData, _orderData,
      statusPayment, Items itemData, int sumNumber) async {
    print('Show Alert Dialog !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '${statusPayment.toString()} ? ',
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
                            _saveStatusPayment(_paymentData, _orderData,
                                statusPayment, itemData, sumNumber);
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

  void _saveStatusPayment(Payment _paymentData, Order _orderData, statusPayment,
      Items itemData, sumNumber) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('กำลังดำเนินการ...')));
    String _date =
        '${_paymentData.date.split('/')[1]}/${_paymentData.date.split('/')[0]}/${_paymentData.date.split('/')[2]}';
    //String status = 'ชำระเงินสำเร็จ';
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
        ///////////////SaveStatusOrder/////////////////
        saveStatusOrder(token, _orderData, statusPayment);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('บันทึกสถานะสำเร็จ')));

        //////////////////UpdateItemCount/////////////////////////////
        if (statusPayment == 'ชำระเงินสำเร็จ') {
          int _number = sumNumber;
          updateItem(_paymentData, _number, statusPayment, itemData);
        } else {
          updateItem(_paymentData, 0, statusPayment, itemData);
        }
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ชำระเงิน ผิดพลาด !')));
      }
    });
  }

  void updateItem(
      Payment _paymentData, int sumNumber, status, Items itemData) async {
    var _dateBegin =
        '${itemData.dateBegin.split('/')[1]}/${itemData.dateBegin.split('/')[0]}/${itemData.dateBegin.split('/')[2]}';
    var _dateFinal =
        '${itemData.dateFinal.split('/')[1]}/${itemData.dateFinal.split('/')[0]}/${itemData.dateFinal.split('/')[2]}';
    var _dealBegin =
        '${itemData.dealBegin.split('/')[1]}/${itemData.dealBegin.split('/')[0]}/${itemData.dealBegin.split('/')[2]}';
    var _dealFinal =
        '${itemData.dealFinal.split('/')[1]}/${itemData.dealFinal.split('/')[0]}/${itemData.dealFinal.split('/')[2]}';

    String _textListSize = itemData.size.toString();
    String textListSize = _textListSize.substring(1, _textListSize.length - 1);
    String _textListColor = itemData.color.toString();
    String textListColor =
        _textListColor.substring(1, _textListColor.length - 1);

    Map params = Map();
    params['itemId'] = itemData.itemId.toString();
    params['marketId'] = itemData.marketId.toString();
    params['nameItems'] = itemData.nameItem.toString();
    params['groupItems'] = itemData.groupItem.toString();
    params['price'] = itemData.price.toString();
    params['priceSell'] = itemData.priceSell.toString();
    params['count'] = (itemData.count + sumNumber).toString();
    params['countRequest'] = itemData.countRequest.toString();
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

          if (itemData.countRequest == (itemData.count + sumNumber)) {
            ///////////////////////////// บันทึกการแจ้งเตือนคนซื้อสินค้านั้นๆ ////////////////////////////////////////
            String textNotifyUser =
                'ยืนยันการชำระเงินสำเร็จ ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${itemData.dateBegin} - ${itemData.dateFinal}';
            notifyUserMethod(context, token, _paymentData.userId,
                _paymentData.payId, _paymentData.amount, textNotifyUser);

            ///////////////////////////// บันทึกการแจ้งเตือนร้านค้าที่ขายสินค้านั้นๆ ////////////////////////////////////////
            String textNotifyMarket =
                'ยืนยันการลงทะเบียนสินค้า Item Id : ${itemData.itemId} ${itemData.nameItem}';
            int _count = (itemData.count + sumNumber).toInt();
            notifyMarketMethod(
                context,
                token,
                _paymentData.marketId,
                _paymentData.payId,
                _count,
                itemData.countRequest,
                textNotifyMarket);

            ///////////////////////////// บันทึกการแจ้งเตือนคนซื้อสินค้านั้นทั้งหมด ////////////////////////////////////////
            print('Notify All user get item');
            String textStatus =
                'จำนวนผู้ลงทะเบียนครบแล้ว ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${itemData.dateBegin} - ${itemData.dateFinal}';
            notifyAllUserMethod(
                context,
                token,
                itemData.itemId,
                _paymentData.userId,
                _paymentData.payId,
                _paymentData.amount,
                textStatus);

            ///////////////////////////// บันทึก Payment Admin ////////////////////////////////////////
            savePaymentAdmin(
                token, adminId, _paymentData.marketId,itemData.itemId, 'รอดำเนินการ');

          } else {
            String textNotifyUser =
                'ยืนยันการชำระเงินสำเร็จ ใช้สิทธิ์รับสินค้าที่ร้านได้ภายในวันที่ ${itemData.dateBegin} - ${itemData.dateFinal}';
            notifyUserMethod(context, token, _paymentData.userId,
                _paymentData.payId, _paymentData.amount, textNotifyUser);

            String textNotifyMarket =
                'ยืนยันการลงทะเบียนสินค้า Item Id : ${itemData.itemId} ${itemData.nameItem}';
            int _count = (itemData.count + sumNumber).toInt();
            notifyMarketMethod(
                context,
                token,
                _paymentData.marketId,
                _paymentData.payId,
                _count,
                itemData.countRequest,
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
}
