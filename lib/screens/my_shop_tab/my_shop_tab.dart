import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/my_shop_tab/edit_product_page.dart';
import 'package:flutter_app_rmuti_market/screens/my_shop_tab/sell_products_tab.dart';
import 'package:http/http.dart' as http;

class MyShop extends StatefulWidget {
  MyShop(this.token, this.marketId);

  final token;
  final marketId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyShop(token,marketId);
  }
}

class _MyShop extends State {
  _MyShop(this.token,this.marketId);

  final token;
  final marketId;

  final urlListItemByUser = "${Config.API_URL}/Item/find/market";
  final urlDeleteProducts = "${Config.API_URL}/Item/delete/";
  final snackBarOnDeleteProducts = SnackBar(content: Text("กำลังลบสินค้า..."));
  final snackBarOnDeleteProductsSuccess =
      SnackBar(content: Text("ลบสินค้า สำเร็จ"));
  final snackBarOnDeleteProductsFall = SnackBar(content: Text("ผิดพลาด !"));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItemByUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SellProducts(token,marketId)));
          },
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: FutureBuilder(
            future: listItemByUser(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.data.length == 0) {
                return Center(
                    child: Text(
                  "No Products",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Container(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                  height: 170,
                                  width: double.infinity,
                                  child: Image.memory(
                                    base64Decode(snapshot.data[index].image),
                                    fit: BoxFit.fill,
                                  )),
                              Opacity(
                                opacity: 0.70,
                                child: Container(
                                  color: Colors.teal,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${snapshot.data[index].name}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${snapshot.data[index].deal_begin} - ${snapshot.data[index].deal_final}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "ราคา ${snapshot.data[index].price_sell} จาก ${snapshot.data[index].price} ต้องการลงชื่อ ${snapshot.data[index].count_request} มีคนลงแล้ว ${snapshot.data[index].count}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Container(
                                                child: snapshot.data[index]
                                                            .count !=
                                                        0
                                                    ? Container()
                                                    : Container(
                                                        height: 20,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    primary: Colors
                                                                        .orange),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          EditProductPage(
                                                                              snapshot.data[index])));
                                                            },
                                                            child: Text(
                                                              "แก้ไข",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ))))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, bottom: 4),
                                        child: Row(
                                          children: [
                                            Text(
                                              "ระยะเวลาการใช้ส่วนลด : ${snapshot.data[index].date_begin} - ${snapshot.data[index].date_final}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        ));
  }

  Future<void> _onRefresh() async {
    listItemByUser();
    setState(() {});
    await Future.delayed(Duration(seconds: 3));
  }

  Future<List<_Items>> listItemByUser() async {
    Map params = Map();
    List<_Items> listItem = [];
    params['market'] = marketId.toString();
    await http.post(Uri.parse(urlListItemByUser), body: params,headers: {HttpHeaders.authorizationHeader:'Bearer ${token.toString()}'}).then((res) {
      print(res.body);
      print("listItem By Account Success");
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _itemData = _jsonRes['data'];
      print(_itemData);
      for (var i in _itemData) {
        _Items _items = _Items(
          i['itemId'],
          i['nameItems'],
          i['imageItems'],
          i['groupItems'],
          i['price'],
          i['priceSell'],
          i['count'],
          i['countRequest'],
          i['marketId'],
          i['dateBegin'],
          i['dateFinal'],
          i['dealBegin'],
          i['dealFinal'],
          i['date'],
        );
        listItem.insert(0, _items);
      }
    });
    print("Products By Account : ${listItem.length}");
    return listItem;
  }
}

class _Items {
  final int? id;
  final String? name;
  final String? image;
  final int? group;
  final int? price;
  final int? price_sell;
  final int? count;
  final int? count_request;
  final int? marketID;
  final String? date_begin;
  final String? date_final;
  final String? deal_begin;
  final String? deal_final;
  final String? date;

  _Items(
      this.id,
      this.name,
      this.image,
      this.group,
      this.price,
      this.price_sell,
      this.count,
      this.count_request,
      this.marketID,
      this.date_begin,
      this.date_final,
      this.deal_begin,
      this.deal_final,
      this.date);
}
