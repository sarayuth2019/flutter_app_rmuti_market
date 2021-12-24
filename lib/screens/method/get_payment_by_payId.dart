import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_all.dart';
import 'package:http/http.dart'as http;



Future<void> getPaymentByPayId(token,int payId) async {
  final String urlGetPayData = '${Config.API_URL}/Pay/listId';
  var paymentData;
  Map params = Map();
  params['id'] = payId.toString();
  await http.post(Uri.parse(urlGetPayData), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    print(jsonData);
    var _paymentData = jsonData['data'];
    Payment _payment = Payment(
        _paymentData['payId'],
        _paymentData['status'],
        _paymentData['userId'],
        _paymentData['orderId'],
        _paymentData['marketId'],
        _paymentData['detail'],
        _paymentData['amount'],
        _paymentData['lastNumber'],
        _paymentData['bankTransfer'],
        _paymentData['bankReceive'],
        _paymentData['date'],
        _paymentData['time'],
        _paymentData['dataTransfer']);
    paymentData = _payment;
  });
  return paymentData;
}