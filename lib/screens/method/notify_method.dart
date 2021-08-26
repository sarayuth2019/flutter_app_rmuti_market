import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

void notifyMethod(
    token, int userId, int marketId, int payId, int amount,String textStatus) async {
  const String urlSaveNotify = '${Config.API_URL} /Notify/save';
  Map params = Map();
  params['userId'] = userId.toString();
  params['marketId'] = marketId.toString();
  params['payId'] = payId.toString();
  params['amount'] = amount.toString();
  params['status'] = textStatus.toString();
  http.post(Uri.parse(urlSaveNotify), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print('res notify : ${res.body}');
  });
}
