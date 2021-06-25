import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/my_order_tab/manage_order.dart';
import 'package:http/http.dart' as http;

class MyOrderTab extends StatefulWidget {
  MyOrderTab(this.accountID);

  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyOrderTab(accountID);
  }
}

class _MyOrderTab extends State {
  _MyOrderTab(this.accountID);

  final int accountID;
  final urlMyOrder = "${Config.API_URL}/Order/find/user";
  final urlSaveNotify = "${Config.API_URL}/Notify/save";
  final urlSaveBackUpNotify = "${Config.API_URL}/Backup/save";
  final urlSaveToOrder = "${Config.API_URL}/Order/save";

  final snackBarOnPickUpOrder = SnackBar(content: Text("กำลังดำเนินการ..."));
  final snackBarSaveStatusOrderFall = SnackBar(content: Text("ผิดพลาด !"));
  final snackBarPickUpOrderSuccess =
      SnackBar(content: Text("ส่งมอบสินค้าสำ สำเร็จ !"));

  var productsData;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamListMyOrder();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder(
        stream: streamListMyOrder(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.length == 0) {
            return Center(
                child: Text(
              "No have order",
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
                        /*
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.memory(
                                base64Decode(snapshot.data[index].image),
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text("PID : ${snapshot.data[index].item_id}")
                          ],
                        ),
                        */

                        Expanded(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order ID : ${snapshot.data[index].id}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${snapshot.data[index].name}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "Customer ID : ${snapshot.data[index].customer_id}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${snapshot.data[index].date}"),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "สถานะสินค้า : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                        child: snapshot.data[index].status == 0
                                            ? Text(
                                                "รอดำเนินการ",
                                                style: TextStyle(
                                                    color: Colors.yellow[700],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Container()),
                                    Container(
                                        child: snapshot.data[index].status == 1
                                            ? Text(
                                                "จัดเตรียมสินค้า สำเร็จ",
                                                style: TextStyle(
                                                    color: Colors.blue[700],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Container()),
                                    Container(
                                        child: snapshot.data[index].status == 2
                                            ? Text(
                                                "ส่งมอบสินค้า สำเร็จ",
                                                style: TextStyle(
                                                    color: Colors.green[700],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Container()),
                                  ],
                                ),
                                Container(
                                    child: snapshot.data[index].status == 0
                                        ? Center(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.yellow[700]),
                                              child: Text(
                                                "จัดการออร์เดอร์",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ManageOrder(
                                                              accountID,
                                                              snapshot
                                                                  .data[index]
                                                                  .id,
                                                              snapshot
                                                                  .data[index]
                                                                  .status,
                                                              snapshot
                                                                  .data[index]
                                                                  .name,
                                                              snapshot
                                                                  .data[index]
                                                                  .number,
                                                              snapshot
                                                                  .data[index]
                                                                  .price,
                                                              snapshot
                                                                  .data[index]
                                                                  .customer_id,
                                                              snapshot
                                                                  .data[index]
                                                                  .seller_id,
                                                              snapshot
                                                                  .data[index]
                                                                  .item_id,
                                                              snapshot
                                                                  .data[index]
                                                                  .date,
                                                              snapshot
                                                                  .data[index]
                                                                  .image,
                                                            )));
                                              },
                                            ),
                                          )
                                        : Container()),
                                Container(
                                    child: snapshot.data[index].status == 1
                                        ? Center(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.green),
                                              child: Text(
                                                "ส่งมอบสินค้า สำเร็จ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                _pickUpOrder(
                                                    snapshot.data[index]);
                                              },
                                            ),
                                          )
                                        : Container()),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text("จำนวน ${snapshot.data[index].number}"),
                                Text(
                                    "ราคา ฿${snapshot.data[index].number * snapshot.data[index].price} "),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
                  }),
            );
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    streamListMyOrder();
    setState(() {});
    await Future.delayed(Duration(seconds: 3));
  }

  void _pickUpOrder(var snapShot) async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnPickUpOrder);
    var _status = 2;
    Map params = Map();
    params['id'] = snapShot.id.toString();
    params['status'] = _status.toString();
    params['name'] = snapShot.name.toString();
    params['number'] = snapShot.number.toString();
    params['price'] = snapShot.price.toString();
    params['customer'] = snapShot.customer_id.toString();
    params['user'] = snapShot.seller_id.toString();
    params['item'] = snapShot.item_id.toString();
    params['image'] = snapShot.image.toString();
    http.post(urlSaveToOrder, body: params).then((res) {
      print(res.body);
      Map jsonData = jsonDecode(res.body);
      var statusData = jsonData['status'];
      if (statusData == 1) {
        var statusText = "ส่งมอบสินค้า สำเร็จ";
        Map _params = Map();
        _params['name'] = snapShot.name.toString();
        _params['number'] = snapShot.number.toString();
        _params['price'] = snapShot.price.toString();
        _params['status'] = statusText.toString();
        _params['user'] = snapShot.customer_id.toString();
        _params['item'] = snapShot.item_id.toString();
        print("save notify...");
        http.post(urlSaveNotify, body: _params).then((res) {
          print("save notify success !");
        });
        http.post(urlSaveBackUpNotify, body: _params).then((res) {
          print("save BackUp notify success !");
        });
        print("save status ${statusData.toString()} to Order success");
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(snackBarPickUpOrderSuccess);
        });
        //snackBarKey.currentState.showSnackBar(snackBarSaveStatusOrderSuccess);
      } else {
        print("save status to Order fall");
        ScaffoldMessenger.of(context).showSnackBar(snackBarSaveStatusOrderFall);
        //snackBarKey.currentState.showSnackBar(snackBarSaveStatusOrderFall);
      }
    });
  }

  Stream<List<_Order>> streamListMyOrder() async* {
    List<_Order> listOrderByAccount = [];
    Map params = Map();
    params['user'] = accountID.toString();
    print("connect to Api Order by Account...");
    await http.post(urlMyOrder, body: params).then((res) {
      print("connect to Api Order by Account Success");
      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;

      if (mounted) {
        setState(() {
          productsData = jsonData['data'];
        });
      }

      for (var p in productsData) {
        _Order _order = _Order(
            p['id'],
            p['status'],
            p['name'],
            p['number'],
            p['price'],
            p['customer'],
            p['user'],
            p['item'],
            p['date'],
            p['image']);
        listOrderByAccount.add(_order);
      }
    });
    yield listOrderByAccount;
  }
}

class _Order {
  final int id;
  final int status;
  final String name;
  final int number;
  final int price;
  final int customer_id;
  final int seller_id;
  final int item_id;
  final String date;
  final String image;

  _Order(
    this.id,
    this.status,
    this.name,
    this.number,
    this.price,
    this.customer_id,
    this.seller_id,
    this.item_id,
    this.date,
    this.image,
  );
}
