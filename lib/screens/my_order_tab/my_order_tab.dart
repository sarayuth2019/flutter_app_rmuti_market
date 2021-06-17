import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

import 'manage_order.dart';

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
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      child: Row(
                    children: [
                      Column(
                        children: [
                          /*ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.memory(
                              base64Decode(snapshot.data[index].image),
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                            ),
                          ),*/
                          Text("PID : ${snapshot.data[index].item_id}")
                        ],
                      ),
                      Expanded(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order ID : ${snapshot.data[index].id}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      child: snapshot.data[index].status == 1
                                          ? Text(
                                              "สำเร็จ",
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "รอดำเนินการ",
                                              style: TextStyle(
                                                  color:
                                                      Colors.yellowAccent[700],
                                                  fontWeight: FontWeight.bold),
                                            )),
                                ],
                              ),
                              Container(
                                  child: snapshot.data[index].status == 0
                                      ? Center(
                                          child: TextButton(
                                            child: Text(
                                              "จัดการออร์เดอร์",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ManageOrder(
                                                            accountID,
                                                            snapshot
                                                                .data[index].id,
                                                            snapshot.data[index]
                                                                .status,
                                                            snapshot.data[index]
                                                                .name,
                                                            snapshot.data[index]
                                                                .number,
                                                            snapshot.data[index]
                                                                .price,
                                                            snapshot.data[index]
                                                                .customer_id,
                                                            snapshot.data[index]
                                                                .seller_id,
                                                            snapshot.data[index]
                                                                .item_id,
                                                            snapshot.data[index]
                                                                .date,
                                                            snapshot.data[index]
                                                                .image,
                                                          )));
                                            },
                                          ),
                                        )
                                      : Container())
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
                });
          }
        },
      ),
    );
  }

  Stream<List<_Order>> streamListMyOrder() async* {
    List<_Order> listOrderByAccount = [];
    Map params = Map();
    params['user'] = accountID.toString();
    print("connect to Api Order by Account...");
    await http.post(urlMyOrder, body: params).then((res) {
      print("connect to Api Order by Account Success");
      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;

     if(mounted){
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
