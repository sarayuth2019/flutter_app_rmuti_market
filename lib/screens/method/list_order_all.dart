import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_order_by_orderId.dart';
import 'package:http/http.dart' as http;

Future<List<Order>> listOrderAll(token) async {
  List<Order> listOrder = [];
  final String urlListOrderAll = '${Config.API_URL}/Order/list';
  await http.get(Uri.parse(urlListOrderAll), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    //print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var data = resData['data'];
    for (var i in data) {
      Order order = Order(
          i['orderId'],
          i['status'],
          i['priceSell'],
          i['marketId'],
          i['userId'],
          i['itemId'],
          i['dateBegin'],
          i['dateFinal'],
          i['dealBegin'],
          i['dealFinal'],
          i['date']);
      listOrder.add(order);
    }
  });
  return listOrder;
}
