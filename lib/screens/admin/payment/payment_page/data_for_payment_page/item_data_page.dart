import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
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
  final String urlGetImageByItemId = "${Config.API_URL}/images/";

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
            FutureBuilder(
              future: getImage(itemId),
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
                                  "ราคา ${snapshot.data.priceSell.toString()} บาท",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "ลดราคาจาก ${snapshot.data.price.toString()} บาท",
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

  Future<_Items?> getItemData(int itemId) async {
    Map params = Map();
    _Items? _items;
    params['id'] = itemId.toString();
    await http.post(Uri.parse(urlGetItemDataByItemId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var itemData = _jsonRes['data'];
      print(itemData);
      _items = _Items(
        itemData['itemId'],
        itemData['nameItems'],
        itemData['groupItems'],
        itemData['price'],
        itemData['priceSell'],
        itemData['count'],
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

  Future<void> getImage(_itemId) async {
    var _resData;
    await http.get(
        Uri.parse('${urlGetImageByItemId.toString()}${_itemId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      print(res.body);
      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _statusData = jsonData['status'];
      var _dataImage = jsonData['dataImages'];
      //var _dataId = jsonData['dataId'];
      if (_statusData == 1) {
        _resData = _dataImage;
        //print("jsonData : ${_resData.toString()}");
      }
    });
    print("_resData ${_resData.toString()}");
    return _resData;
  }
}

class _Items {
  final int itemId;
  final String nameItem;
  final int groupItems;
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
      this.groupItems,
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
