import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

Future<Order?> getOrderByOrderId(token, orderId) async {
  final urlGetOrderByOrderId = '${Config.API_URL}/Order/listId';
  Order? order;
  Map params = Map();
  params['id'] = orderId.toString();
  await http.post(Uri.parse(urlGetOrderByOrderId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var data = resData['data'];
    Order _order = Order(
        data['orderId'],
        data['status'],
        data['priceSell'],
        data['marketId'],
        data['userId'],
        data['itemId'],
        data['dateBegin'],
        data['dateFinal'],
        data['dealBegin'],
        data['dealFinal'],
        data['date']);
    order = _order;
  });
  return order;
}

class Order {
  Order(
      this.orderId,
      this.status,
      this.priceSell,
      this.marketId,
      this.userId,
      this.itemId,
      this.dateBegin,
      this.dateFinal,
      this.dealBegin,
      this.dealFinal,
      this.date);

  final orderId;
  final status;
  final priceSell;
  final marketId;
  final userId;
  final itemId;
  final dateBegin;
  final dateFinal;
  final dealBegin;
  final dealFinal;
  final date;
}
