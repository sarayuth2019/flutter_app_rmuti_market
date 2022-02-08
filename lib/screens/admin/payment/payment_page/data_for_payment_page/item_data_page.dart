import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/my_shop_tab/my_shop_tab.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_image_Item.dart';
import 'package:http/http.dart' as http;

class ItemDataPage extends StatefulWidget {
  ItemDataPage(this.token, this.itemId);

  final token;
  final itemId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemDataPage(token, itemId);
  }
}

class _ItemDataPage extends State {
  _ItemDataPage(this.token, this.itemId);

  final token;
  final itemId;
  final String urlGetItemDataByItemId = '${Config.API_URL}/Item/list/item';

  var size;
  int _sizePrice = 0;
  bool _checkSelectSize = false;
  var color;
  int _colorPrice = 0;
  bool _checkSelectColor = false;
  var textStyle = TextStyle(fontSize: 12);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowImageItem(token, itemId),
            SizedBox(
              height: 15,
            ),
            FutureBuilder(
              future: getItemData(itemId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                            child: snapshot.data.size[0] == 'null'
                                ? Container()
                                : Container(
                                    child: _checkSelectSize == false
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _checkSelectSize =
                                                    !_checkSelectSize;
                                              });
                                            },
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      child: size == null
                                                          ? Container(
                                                              child: Text(
                                                                  'เลือกขนาด '),
                                                            )
                                                          : Container(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'ขนาด : ${size.split(':')[0].toString()}',
                                                                    style:
                                                                        textStyle,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    '+${size.split(':')[1].toString()} บาท',
                                                                    style:
                                                                        textStyle,
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                  Icon(
                                                    Icons.arrow_right_outlined,
                                                    color: Colors.teal,
                                                    size: 35,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: boxDecorationGrey,
                                            height: 40,
                                            width: double.infinity,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  snapshot.data.size.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      size = snapshot
                                                          .data.size[index];
                                                      _sizePrice = int.parse(
                                                          snapshot
                                                              .data.size[index]
                                                              .split(':')[1]);
                                                      _checkSelectSize =
                                                          !_checkSelectSize;
                                                    });
                                                  },
                                                  child: Card(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${snapshot.data.size[index]}',
                                                      style: textStyle,
                                                    ),
                                                  )),
                                                );
                                              },
                                            ),
                                          ))),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                            child: snapshot.data.colors[0] == 'null'
                                ? Container()
                                : Container(
                                    child: _checkSelectColor == false
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _checkSelectColor =
                                                    !_checkSelectColor;
                                              });
                                            },
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      child: color == null
                                                          ? Container(
                                                              child: Text(
                                                                  'เลือกสี'),
                                                            )
                                                          : Container(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'สี : ${color.split(':')[0].toString()}',
                                                                    style:
                                                                        textStyle,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    '+${color.split(':')[1].toString()} บาท',
                                                                    style:
                                                                        textStyle,
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                  Icon(
                                                    Icons.arrow_right_outlined,
                                                    color: Colors.teal,
                                                    size: 35,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: boxDecorationGrey,
                                            height: 40,
                                            width: double.infinity,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  snapshot.data.colors.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      color = snapshot
                                                          .data.colors[index];
                                                      _colorPrice = int.parse(
                                                          snapshot.data
                                                              .colors[index]
                                                              .split(':')[1]);
                                                      _checkSelectColor =
                                                          !_checkSelectColor;
                                                    });
                                                  },
                                                  child: Card(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${snapshot.data.colors[index]}',
                                                      style: textStyle,
                                                    ),
                                                  )),
                                                );
                                              },
                                            ),
                                          ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: boxDecorationGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data.nameItem,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                        child: snapshot.data.groupItems == 1
                                            ? Text('(สินค้าพร้อมขาย)')
                                            : Text('(สินค้า Pre order)'))
                                  ],
                                ),
                                Text(
                                  "ราคา ${snapshot.data.priceSell + _sizePrice + _colorPrice} บาท",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "ลดราคาจาก ${snapshot.data.price + _sizePrice + _colorPrice} บาท",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "จำนวนคนที่ต้องการ ${snapshot.data.countRequest} คน",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "มีผู้เข้าร่วมแล้ว ${snapshot.data.count} คน",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: boxDecorationGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ระยะเวลาลงทะเบียนเข้าร่วม",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${snapshot.data.dealBegin} - ${snapshot.data.dealFinal}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "ระยะเวลาที่สามารถใช้สิทธิ์ได้",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${snapshot.data.dateBegin} - ${snapshot.data.dateFinal}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future<Item?> getItemData(int itemId) async {
    Map params = Map();
    Item? _items;
    params['id'] = itemId.toString();
    await http.post(Uri.parse(urlGetItemDataByItemId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var itemData = _jsonRes['data'];
      print(itemData);
      _items = Item(
        itemData['itemId'],
        itemData['nameItems'],
        itemData['groupItems'],
        itemData['price'],
        itemData['priceSell'],
        itemData['count'],
        itemData['size'],
        itemData['colors'],
        itemData['countRequest'],
        itemData['marketId'],
        itemData['dateBegin'],
        itemData['dateFinal'],
        itemData['dealBegin'],
        itemData['dealFinal'],
        itemData['createDate'],
      );
    });
    return _items;
  }
}

class ShowImageItem extends StatefulWidget {
  ShowImageItem(this.token, this.itemId);

  final token;
  final int itemId;

  @override
  _ShowImageItemState createState() => _ShowImageItemState(token, itemId);
}

class _ShowImageItemState extends State<ShowImageItem> {
  _ShowImageItemState(this.token, this.itemId);

  final token;
  final int itemId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImage(token, itemId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshotImage) {
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
                  initialPage: 0, enlargeCenterPage: true, autoPlay: true),
              itemCount: snapshotImage.data.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
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
    );
  }
}
