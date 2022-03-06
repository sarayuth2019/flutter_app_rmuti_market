import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/admin/sold_items_admin/list_order_by_item/edit_payment_admin_to_market.dart';
import 'package:flutter_app_rmuti_market/screens/admin/sold_items_admin/list_order_by_item/payment_admin_to_market_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/sold_items_admin/list_order_by_item/show_order_detail.dart';
import 'package:flutter_app_rmuti_market/screens/admin/sold_items_admin/list_order_by_item/show_payment_admin_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/getDetailOrder.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_image_Item.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_item_by_itemId.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_order_by_orderId.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_admin_by_itemId.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_orders_by_ItemId.dart';

class ListOrderByItemPage extends StatefulWidget {
  ListOrderByItemPage(this.token, this.adminId, this.itemData);

  final token;
  final adminId;
  final Items itemData;

  @override
  _ListOrderByItemPageState createState() =>
      _ListOrderByItemPageState(token, adminId, itemData);
}

class _ListOrderByItemPageState extends State<ListOrderByItemPage> {
  _ListOrderByItemPageState(this.token, this.adminId, this.itemData);

  final token;
  final adminId;
  final Items itemData;

  List<Order> listOrders = [];
  List<Detail> listOrdersDetail = [];

  Future<void> _refreshPage() async {
    setState(() {
      print('Set State !!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.teal),
          title: Text(
            '${itemData.itemId} : ${itemData.nameItem}',
            style: TextStyle(fontSize: 17, color: Colors.teal),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: getImage(token, itemData.itemId),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshotImage) {
                  print(snapshotImage.data.runtimeType);
                  if (snapshotImage.data == null) {
                    return Container(
                        height: 150,
                        width: double.infinity,
                        decoration: boxDecorationGrey,
                        child: Center(child: Text('กำลังโหลดภาพ...')));
                  } else {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                            initialPage: 0,
                            enlargeCenterPage: true,
                            autoPlay: true),
                        itemCount: snapshotImage.data.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          return Container(
                              child: snapshotImage.data.length == 0
                                  ? Container(
                                      child:
                                          Center(child: Text('กำลังโหลดภาพ...')))
                                  : Container(
                                      height: 150,
                                      width: double.infinity,
                                      child: Image.memory(
                                          base64Decode(snapshotImage.data[index]),
                                          fit: BoxFit.fill)));
                        },
                      ),
                    );
                  }
                },
              ),
              FutureBuilder(
                future: listOrdersByItemId(token, itemData.itemId),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshotListOrders) {
                  if (snapshotListOrders.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshotListOrders.data.length == 0) {
                    return Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'ยังไม่มีการลงทะเบียนซื้อ',
                          )),
                    );
                  } else {
                    listOrders = snapshotListOrders.data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: boxDecorationGrey,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${itemData.nameItem}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      'จำนวนการลงทะเบียนซื้อ : ${itemData.count}/${itemData.countRequest}')
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 4.0),
                            child: Text(
                              'รายการการลงทะเบียน',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshotListOrders.data.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: boxDecorationGrey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Order Id : ${snapshotListOrders.data[index].orderId}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                  'จำนวนเงิน : ${snapshotListOrders.data[index].priceSell} บาท'),
                                            ],
                                          ),
                                          FutureBuilder(
                                            future: getDetailOrder(
                                                token,
                                                snapshotListOrders
                                                    .data[index].orderId),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshotOrderDetail) {
                                              if (snapshotOrderDetail.data ==
                                                  null) {
                                                return Text('กำลังโหลด...');
                                              } else {
                                                listOrdersDetail =
                                                    snapshotOrderDetail.data;
                                                return TextButton(
                                                    onPressed: () {
                                                      showOrderDetail(
                                                          context,
                                                          token,
                                                          snapshotOrderDetail
                                                              .data);
                                                    },
                                                    child: Text(
                                                      'รายละเอียด',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.teal),
                                                    ));
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          Text(
                              'รวมเป็นเงิน : ${listOrders.map((e) => e.priceSell).reduce((a, b) => a + b)} บาท',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future:
                                getPaymentAdminByItemId(token, itemData.itemId),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic>
                                    snapshotGetPaymentAdminByItemId) {
                              if (snapshotGetPaymentAdminByItemId.data == null) {
                                return Text('กำลังโหลด...');
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      'สถานะ : ${snapshotGetPaymentAdminByItemId.data.status}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    snapshotGetPaymentAdminByItemId.data.status ==
                                            'รอดำเนินการ'
                                        ? buttonTab1()
                                        : Container(),
                                    snapshotGetPaymentAdminByItemId.data.status ==
                                            'รอตรวจสอบจากร้านค้า'
                                        ? buttonTab2(
                                            snapshotGetPaymentAdminByItemId.data)
                                        : Container(),
                                    snapshotGetPaymentAdminByItemId.data.status ==
                                            'ชำระเงินสำเร็จ'
                                        ? buttonTab3(
                                            snapshotGetPaymentAdminByItemId.data)
                                        : Container(),
                                    snapshotGetPaymentAdminByItemId.data.status ==
                                            'ชำระเงินผิดพลาด'
                                        ? buttonTab4(
                                            snapshotGetPaymentAdminByItemId.data)
                                        : Container(),
                                  ],
                                );
                              }
                            },
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonTab1() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.teal),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PaymentAminToMarket(
                      token, adminId, listOrders, listOrdersDetail, itemData)));
        },
        child: Text(
          'โอนเงินไปยังร้านค้า',
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget buttonTab2(paymentAdminData) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.amber),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ShowPaymentAdminPage(token, paymentAdminData)));
        },
        child: Text(
          'สลีปการโอนเงิน',
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget buttonTab3(paymentAdminData) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.green),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ShowPaymentAdminPage(token, paymentAdminData)));
        },
        child: Text(
          'สลีปการโอนเงิน',
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget buttonTab4(paymentAdminData) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EditPaymentAdminToMarket(
                      token, adminId, paymentAdminData)));
        },
        child: Text(
          'ตรวจสอบ/แก้ไข',
          style: TextStyle(color: Colors.white),
        ));
  }
}
