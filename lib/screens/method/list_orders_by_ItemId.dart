import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_order_by_orderId.dart';
import 'package:http/http.dart' as http;

Future<List<Order>> listOrdersByItemId(token, int itemId) async {
  String urlListOrderByItemId = '${Config.API_URL}/Order/listOrderByItemId';
  List<Order> listOrdersByItemId = [];
  Map params = Map();
  params['itemId'] = itemId.toString();
  await http.post(Uri.parse(urlListOrderByItemId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    //print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var listOrderData = resData['data'];
    for (var i in listOrderData) {
      Order _order = Order(
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
      listOrdersByItemId.add(_order);
    }
    return listOrdersByItemId;
  });

  return listOrdersByItemId;
}
