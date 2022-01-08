import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_all.dart';
import 'package:http/http.dart' as http;

Future<List<Payment>> listPaymentByMarketId(token, int marketId) async {
  final String urlGetPaymentByMarketId = '${Config.API_URL}/Pay/market';
  List<Payment> listPaymentOverview = [];
  List<Payment> listPaymentByMarketId = [];
  Map params = Map();
  params['marketId'] = marketId.toString();
  await http.post(Uri.parse(urlGetPaymentByMarketId), body: params, headers: {
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
      listPaymentByMarketId.add(_payment);
    }
    List<Payment> listStatus1 = listPaymentByMarketId
        .where(
            (element) => element.status.toString().contains('ชำระเงินสำเร็จ'))
        .toList();
    List<Payment> listStatus2 = listPaymentByMarketId
        .where(
            (element) => element.status.toString().contains('รับสินค้าสำเร็จ'))
        .toList();
    List<Payment> listStatus3 = listPaymentByMarketId
        .where((element) => element.status.toString().contains('รีวิวสำเร็จ'))
        .toList();
    listPaymentOverview = listStatus1 + listStatus2 + listStatus3;
  });
  return listPaymentOverview;
}
