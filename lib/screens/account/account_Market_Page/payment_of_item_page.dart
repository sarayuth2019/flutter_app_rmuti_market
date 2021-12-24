import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_all.dart';
import 'package:http/http.dart' as http;

class PaymentOfItemId extends StatefulWidget {
  PaymentOfItemId(this.token, this.itemId);

  final token;
  final int itemId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentOfItemId(token, itemId);
  }
}

class _PaymentOfItemId extends State {
  _PaymentOfItemId(this.token, this.itemId);

  final token;
  final int itemId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          'Item Id : ${itemId.toString()}',
          style: TextStyle(color: Colors.teal),
        ),
      ),
      body: FutureBuilder(
        future: listPaymentByItemId(itemId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: boxDecorationGrey,
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Id : ${snapshot.data[index].payId}'),
                          Text(
                              'ผู้ชำระเงิน User Id : ${snapshot.data[index].payId}'),
                          Text(
                              'จำนวนสินค้า : ${snapshot.data[index].number}'),
                          Text(
                              'จำนวนเงิน : ${snapshot.data[index].amount} บาท'),
                          Row(
                            children: [
                              Text('สถานะ : '),
                              Container(
                                  child: snapshot.data[index].status ==
                                          'ชำระเงินสำเร็จ'
                                      ? Text(
                                          '${snapshot.data[index].status} (ยังไม่มารับสินค้า)',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : Text(
                                          '${snapshot.data[index].status}',
                                          style:
                                              TextStyle(color: Colors.blue)))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Payment>> listPaymentByItemId(int itemId) async {
    List<Payment> listPayment = [];
    final String urlGetPaymentByItemId = '${Config.API_URL}/Pay/item';
    Map params = Map();
    params['itemId'] = itemId.toString();
    await http.post(Uri.parse(urlGetPaymentByItemId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      var listPaymentData = jsonData['data'];
      print(listPaymentData);
      for (var i in listPaymentData) {
        Payment payment = Payment(
            i['payId'],
            i['status'],
            i['userId'],
            i['orderId'],
            i['marketId'],
            i['detail'],
            i['amount'],
            i['lastNumber'],
            i['bankTransfer'],
            i['bankReceive'],
            i['date'],
            i['time'],
            i['dataTransfer']);
        listPayment.add(payment);
      }
    });

    return listPayment;
  }
}
