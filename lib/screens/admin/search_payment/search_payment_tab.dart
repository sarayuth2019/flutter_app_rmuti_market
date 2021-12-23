import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/payment_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_tab.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;

class SearchPayment extends StatefulWidget {
  SearchPayment(this.token);

  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPayment(token);
  }
}

class _SearchPayment extends State {
  _SearchPayment(this.token);

  final token;
  final String urlGetAllPayment = '${Config.API_URL}/Pay/list';
  List<Payment?> _listAllPayment = [];
  List<Payment?> _listSearchPayment = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
            decoration: boxDecorationGrey,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search Payment Id', border: InputBorder.none),
                onChanged: (textSearch) {
                  setState(() {
                    _listSearchPayment = _listAllPayment
                        .where((element) => element!.payId
                            .toString()
                            .toLowerCase()
                            .contains(textSearch.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: getAllPaymentData(token),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: _listSearchPayment.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: boxDecorationGrey,
                      child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Payment Id : ${_listSearchPayment[index]!.payId}'),
                              Text(
                                  'สถานะ : ${_listSearchPayment[index]!.status}'),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                          token, _listSearchPayment[index])));
                            },
                            iconSize: 20,
                            icon: Icon(
                              Icons.search,
                              color: Colors.teal,
                            ),
                          )),
                    ),
                  );
                },
              );
            }
          },
        ));
  }

  Future<void> getImagePay(int paymentId) async {
    final String urlGetPayImage = '${Config.API_URL}/ImagePay/listId';
    var imagePay;
    Map params = Map();
    params['payId'] = paymentId.toString();
    await http.post(Uri.parse(urlGetPayImage), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      var imagePayData = jsonData['dataImages'];
      imagePay = imagePayData;
    });
    return imagePay;
  }

  Future<List<Payment?>> getAllPaymentData(token) async {
    List<Payment?> listAllPayment = [];
    await http.get(Uri.parse(urlGetAllPayment), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      print(jsonData);
      var payData = jsonData['data'];
      for (var i in payData) {
        Payment _payment = Payment(
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
        listAllPayment.insert(0, _payment);
      }
      _listAllPayment = listAllPayment;
    });
    return listAllPayment;
  }
}

