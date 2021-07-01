import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

class ManageOrder extends StatefulWidget {
  ManageOrder(
      this.accountID,
      this.id,
      this.status,
      this.name,
      this.number,
      this.price,
      this.customer_id,
      this.seller_id,
      this.item_id,
      this.date,
      this.image);

  final accountID;
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

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ManageOrder(accountID, id, status, name, number, price, customer_id,
        seller_id, item_id, date, image);
  }
}

class _ManageOrder extends State {
  _ManageOrder(
      this.accountID,
      this.id,
      this.status,
      this.name,
      this.number,
      this.price,
      this.customer_id,
      this.seller_id,
      this.item_id,
      this.date,
      this.image);

  final int accountID;
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

  final snackBarKey = GlobalKey<ScaffoldState>();
  final urlSaveToOrder = "${Config.API_URL}/Order/save";
  final urlCancelOrder = "${Config.API_URL}/Order/delete/";
  final urlSaveNotify = "${Config.API_URL}/Notify/save";
  final urlSaveBackUpNotify = "${Config.API_URL}/Backup/save";

  final snackBarSaveStatusOrderFall = SnackBar(content: Text("ผิดพลาด !"));
  final snackBarSaveStatusOrderSuccess =
      SnackBar(content: Text("จัดเตรียมสินค้า สำเร็จ !"));
  final snackBarCancelOrderSuccess =
      SnackBar(content: Text("ยกเลิกฮอร์เดอร์ สำเร็จ !"));
  final snackBarOnTab =
      SnackBar(content: Text("กำลังดำเนินการ กรุณารอซักครู่..."));
  var _status;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: snackBarKey,
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text("Manage Order ID : ${id.toString()}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "สถานะสินค้า : ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    child: status == 0
                        ? Text(
                      "รอดำเนินการ",
                      style: TextStyle(
                          color: Colors.yellow[600],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                        : Container()),
                Container(
                    child: status == 1
                        ? Text(
                      "จัดเตรียมสินค้าสำเร็จ",
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                        : Container()),
                Container(
                    child: status == 2
                        ? Text(
                            "ส่งมอบสินค้าแล้ว สำเร็จ",
                            style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        : Container()),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    child: Image.memory(
                      base64Decode(image),
                      fit: BoxFit.fill,
                      height: 250,
                      width: 310,
                    ),
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ชื่อสินค้า : ${name.toString()}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("จำนวน : ${number.toString()}",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("ราคาต่อชิ้น : ฿${price.toString()}",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("รวมเป็นเงิน : ฿${(number * price).toString()}",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(
                      child: status == 1
                          ? Text("วันเวลาที่สำเร็จ : ${date.toString()}",
                              style: TextStyle(fontSize: 18))
                          : Text("วันเวลาที่สั่ง : ${date.toString()}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text("จัดเตรียมสำเร็จ",
                                style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              _showAlertOrderSuccess(context);
                            },
                          ),
                          TextButton(
                            child: Text("สินค้าหมด",
                                style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              _showAlertCancelOrder(context);
                            },
                          ),
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
  }

  void _showAlertOrderSuccess(BuildContext context) async {
    print('Show Alert Dialog Order Success !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("จัดเตรียมสินค้าสำเร็จ"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ยืนยัน'),
                          onTap: () {
                            setState(() {
                              _status = 1;
                            });
                            Navigator.of(context).pop();
                            _saveStatusOrderSuccess();
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('ยกเลิก'),
                          onTap: () {
                            Navigator.of(context).pop();
                          })),
                ],
              ),
            ),
          );
        });
  }

  void _showAlertCancelOrder(BuildContext context) async {
    print('Show Alert Dialog Out of Product !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ต้องการยกเลิกออร์เดอร์"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ยืนยัน'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _saveStatusCancelOrder();
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('ยกเลิก'),
                          onTap: () {
                            Navigator.of(context).pop();
                          })),
                ],
              ),
            ),
          );
        });
  }

  void _saveStatusOrderSuccess() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnTab);
    Map params = Map();
    params['id'] = id.toString();
    params['status'] = _status.toString();
    params['name'] = name.toString();
    params['number'] = number.toString();
    params['price'] = price.toString();
    params['customer'] = customer_id.toString();
    params['user'] = seller_id.toString();
    params['item'] = item_id.toString();
    params['image'] = image.toString();
    http.post(Uri.parse(urlSaveToOrder), body: params).then((res) {
      print(res.body);
      Map jsonData = jsonDecode(res.body);
      var statusData = jsonData['status'];
      if (statusData == 1) {
        var statusText = "จัดเตรียมสินค้า สำเร็จ";
        Map _params = Map();
        _params['name'] = name.toString();
        _params['number'] = number.toString();
        _params['price'] = price.toString();
        _params['status'] = statusText.toString();
        _params['user'] = customer_id.toString();
        _params['item'] = item_id.toString();
        print("save notify...");
        http.post(Uri.parse(urlSaveNotify),body: _params).then((res){
          print("save notify success !");
        });
        http.post(Uri.parse(urlSaveBackUpNotify),body: _params).then((res){
          print("save BackUp notify success !");
        });
        print("save status ${statusData.toString()} to Order success");
        ScaffoldMessenger.of(context).showSnackBar(snackBarSaveStatusOrderSuccess);
        //snackBarKey.currentState.showSnackBar(snackBarSaveStatusOrderSuccess);
        Navigator.of(context).pop();
      } else {
        print("save status to Order fall");
        ScaffoldMessenger.of(context).showSnackBar(snackBarSaveStatusOrderFall);
        //snackBarKey.currentState.showSnackBar(snackBarSaveStatusOrderFall);
      }
    });
  }

  void _saveStatusCancelOrder() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnTab);
    http.get(Uri.parse("${urlCancelOrder}${id}")).then((res) {
      print(res.body);
      var jsonData = jsonDecode(res.body);
      var statusData = jsonData['status'];
      print("status data : ${statusData.toString()}");
      if (statusData == 1) {
        var statusText = "สินค้าหมด";
        Map _params = Map();
        _params['name'] = name.toString();
        _params['number'] = number.toString();
        _params['price'] = price.toString();
        _params['status'] = statusText.toString();
        _params['user'] = customer_id.toString();
        _params['item'] = item_id.toString();
        _params['image'] = image.toString();
        print("save notify...");
        http.post(Uri.parse(urlSaveNotify),body: _params).then((res){
          print("save notify success !");
        });
        http.post(Uri.parse(urlSaveBackUpNotify),body: _params).then((res){
          print("save BackUp notify success !");
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBarCancelOrderSuccess);
        //snackBarKey.currentState.showSnackBar(snackBarCancelOrderSuccess);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBarSaveStatusOrderFall);
        //snackBarKey.currentState.showSnackBar(snackBarSaveStatusOrderFall);
      }
    });
  }
}
