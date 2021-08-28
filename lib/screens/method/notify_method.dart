import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

void notifyMethod(context,token, int userId, int marketId, int payId, int amount,
    String textStatus) async {
  print('Notify to user id ${userId.toString()}');
  const String urlSaveNotify = '${Config.API_URL}/Notify/save';
  Map params = Map();
  params['userId'] = userId.toString();
  params['marketId'] = marketId.toString();
  params['payId'] = payId.toString();
  params['amount'] = amount.toString();
  params['status'] = textStatus.toString();
  await http.post(Uri.parse(urlSaveNotify), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    print('res notify : ${jsonData.toString()}');
    var statusRes = jsonData['status'];
    if(statusRes != 1){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เพิ่มจำนวนคนไปยัง item นั้นผิดพลาด')));
    }
  });
}
