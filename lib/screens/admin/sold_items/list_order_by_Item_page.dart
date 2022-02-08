import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_image_Item.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_item_by_itemId.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_orders_by_ItemId.dart';

class ListOrderByItemPage extends StatefulWidget {
  ListOrderByItemPage(this.token, this.itemData);

  final token;
  final Items itemData;

  @override
  _ListOrderByItemPageState createState() =>
      _ListOrderByItemPageState(token, itemData);
}

class _ListOrderByItemPageState extends State<ListOrderByItemPage> {
  _ListOrderByItemPageState(this.token, this.itemData);

  final token;
  final Items itemData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          '${itemData.itemId} : ${itemData.nameItem}',
          style: TextStyle(fontSize: 17, color: Colors.teal),
        ),
      ),
      body: Column(
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
                                  child: Center(child: Text('กำลังโหลดภาพ...')))
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
                        'ยังไม่มีคนลงทะเบียน',
                      )),
                );
              } else {
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  'จำนวนผู้ลงทะเบียน : ${itemData.count}/${itemData.countRequest}')
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                        child: Text(
                          'รายการการลงทะเบียน',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
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
                                      TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'รายละเอียด',
                                            style:
                                                TextStyle(fontSize: 14,color: Colors.teal),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      Text(
                          'รวมเป็นเงิน : ${snapshotListOrders.data.map((e) => e.priceSell).reduce((a, b) => a + b)} บาท',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
