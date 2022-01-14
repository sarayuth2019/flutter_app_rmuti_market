import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart'as http;

Future<List<_Notify>> listNotifyMarket(token,marketId) async {
  final String urlListNotifyByMarketId =
      '${Config.API_URL}/MarketNotify/list/market';
  List<_Notify> listNotify = [];
  Map params = Map();
  params['marketId'] = marketId.toString();
  await http.post(Uri.parse(urlListNotifyByMarketId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    var resData = jsonData['data'];
    for (var i in resData) {
      _Notify _notify = _Notify(i['notifyId'], i['count'], i['countRequest'],
          i['status'], i['marketId'], i['payId'], i['createDate']);
      listNotify.insert(0, _notify);
    }
  });
  return listNotify;
}

class _Notify {
  final int notifyId;
  final int count;
  final int countRequest;
  final String status;
  final int marketId;
  final int payId;
  final String createDate;

  _Notify(this.notifyId, this.count, this.countRequest, this.status,
      this.marketId, this.payId, this.createDate);
}