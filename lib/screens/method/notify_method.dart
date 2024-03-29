import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

void notifyUserMethod(context, token, int userId, int payId, int amount,
    String textStatus) async {
  print('Notify to user id ${userId.toString()}');
  const String urlSaveUserNotify = '${Config.API_URL}/UserNotify/save';
  Map params = Map();
  params['userId'] = userId.toString();
  params['payId'] = payId.toString();
  params['amount'] = amount.toString();
  params['status'] = textStatus.toString();
  await http.post(Uri.parse(urlSaveUserNotify), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    print('res notify : ${jsonData.toString()}');
    var statusRes = jsonData['status'];
    if (statusRes != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('บันทึกการแจ้งเตือน ผู้ใช้ ผิดพลาด')));
    }
  });
}

void notifyMarketMethod(context, token, int marketId, int payId, int count,
    int countRequest, String textStatus) async {
  print('Notify to user id ${marketId.toString()}');
  const String urlSaveMarketNotify = '${Config.API_URL}/MarketNotify/save';
  Map params = Map();
  params['marketId'] = marketId.toString();
  params['payId'] = payId.toString();
  params['count'] = count.toString();
  params['countRequest'] = countRequest.toString();
  params['status'] = textStatus.toString();
  await http.post(Uri.parse(urlSaveMarketNotify), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    print('res notify : ${jsonData.toString()}');
    var statusRes = jsonData['status'];
    if (statusRes != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('บันทึกการแจ้งเตือน ร้านค้า ผิดพลาด')));
    }
  });
}

void notifyAllUserMethod(context, token, int itemId, int userId, int payId,
    int amount, String textStatus) async {
  const String urlListPaymentByItemId =
      '${Config.API_URL}/Pay/listUserIdAndPayIdByItemId';
  Map params = Map();
  params['itemId'] = itemId.toString();
  await http.post(Uri.parse(urlListPaymentByItemId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print(res.body);
    var _res = jsonDecode(utf8.decode(res.bodyBytes));
    var resUserIdNotify = _res['data1'];

    //List _listUserIdNotify = resData.toSet().toList();
    //print(_listUserIdNotify);

    resUserIdNotify.forEach((element) {
      print('userId : ${element[0]} payId : ${element[1]}');
      notifyUserMethod(
          context, token, element[0], element[1], amount, textStatus);
    });
  });
}
