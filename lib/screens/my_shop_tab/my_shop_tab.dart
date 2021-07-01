import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/my_shop_tab/sell_products_tab.dart';
import 'package:http/http.dart' as http;

import 'edit_product_page.dart';

class MyShop extends StatefulWidget {
  MyShop(this.accountID);

  final accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyShop(accountID);
  }
}

class _MyShop extends State {
  _MyShop(this.accountID);

  final accountID;

  final urlListItemByUser = "${Config.API_URL}/Item/find/user";
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
          backgroundColor: Colors.orange[600],
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SellProducts(accountID)));
          },
        ),
        body: Container(
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
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.memory(
                                          base64Decode(
                                              snapshot.data[index].image),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.fill,
                                        )),
                                    Text("PID : ${snapshot.data[index].id}"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${snapshot.data[index].name}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("฿${snapshot.data[index].price}"),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                          Text(
                                              "${snapshot.data[index].location}"),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.amber,
                                        size: 17,
                                      ),
                                      onPressed: () {
                                        print(
                                            "Edit Product ID ${snapshot.data[index].id}");
                                        Navigator.push(
                                            context,
                                            (MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProductPage(
                                                      snapshot.data[index].id,
                                                      snapshot.data[index].name,
                                                      snapshot
                                                          .data[index].group,
                                                      snapshot.data[index]
                                                          .description,
                                                      snapshot
                                                          .data[index].price,
                                                      snapshot
                                                          .data[index].location,
                                                      snapshot
                                                          .data[index].user_id,
                                                      snapshot
                                                          .data[index].discount,
                                                      snapshot.data[index]
                                                          .count_promotion,
                                                      snapshot.data[index]
                                                          .status_promotion,
                                                      snapshot.data[index].date,
                                                      snapshot
                                                          .data[index].image,
                                                    ))));
                                      }),
                                  IconButton(
                                      onPressed: () {
                                        _showAlertDeleteProducts(
                                            context, snapshot.data[index].id);
                                      },
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red,
                                        size: 17,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                );
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

  void _showAlertDeleteProducts(BuildContext context, snapshotIndexID) async {
    print('Show Alert Dialog Delete Product !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ยืนยันการลบสินค้า'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ยืนยัน'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _deleteProduct(snapshotIndexID);
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

  void _deleteProduct(var snapshotIndexID) {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnDeleteProducts);
    http.get(Uri.parse("${urlDeleteProducts}${snapshotIndexID}")).then((res) {
      print(res.body);
      var dataRes = jsonDecode(res.body);
      var statusRes = dataRes['status'];
      print(statusRes);
      if (statusRes == 0) {
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarOnDeleteProductsSuccess);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarOnDeleteProductsFall);
      }
    });
  }

  Future<List<_Products>> listItemByUser() async {
    Map params = Map();
    List<_Products> listItem = [];
    params['user'] = accountID.toString();
    await http.post(Uri.parse(urlListItemByUser), body: params).then((res) {
      print("listItem By Account Success");
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _itemData = _jsonRes['data'];

      for (var i in _itemData) {
        _Products _products = _Products(
            i['id'],
            i['name'],
            i['group'],
            i['description'],
            i['price'],
            i['location'],
            i['user'],
            i['discount'],
            i['count_promotion'],
            i['promotion'],
            i['date'],
            i['image']);
        listItem.insert(0, _products);
      }
    });
    print("Products By Account : ${listItem.length}");
    return listItem;
  }
}

class _Products {
  final int id;
  final String name;
  final int group;
  final String description;
  final int price;
  final String location;
  final int user_id;
  final int discount;
  final int count_promotion;
  final int status_promotion;
  final String date;
  final String image;

  _Products(
      this.id,
      this.name,
      this.group,
      this.description,
      this.price,
      this.location,
      this.user_id,
      this.discount,
      this.count_promotion,
      this.status_promotion,
      this.date,
      this.image);
}
