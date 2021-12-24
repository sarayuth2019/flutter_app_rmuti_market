import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter_app_rmuti_market/config/config.dart';

Future<void> saveStatusOrder(token,orderData,statusOrder) async {
  final String urlOrderUpdate = '${Config.API_URL}/Order/update';
  var _dealBegin =
      '${orderData.dealBegin.split('/')[1]}/${orderData.dealBegin
      .split('/')[0]}/${orderData.dealBegin.split('/')[2]}';
  var _dealFinal =
      '${orderData.dealFinal.split('/')[1]}/${orderData.dealFinal
      .split('/')[0]}/${orderData.dealFinal.split('/')[2]}';
  var _dateBegin =
      '${orderData.dateBegin.split('/')[1]}/${orderData.dateBegin
      .split('/')[0]}/${orderData.dateBegin.split('/')[2]}';
  var _dateFinal =
      '${orderData.dateFinal.split('/')[1]}/${orderData.dateFinal
      .split('/')[0]}/${orderData.dateFinal.split('/')[2]}';
  //print('_dealBegin เริ่ม ลงทะเบียน : ${_dealBegin.toString()}');
  //print('_dealFinal สิ้นสุด ลงทะเบียน : ${_dealFinal.toString()}');
  //print('_dateBegin เริ่ม รับสินค้า : ${_dateBegin.toString()}');
  //print(' _dateFinal สิ้นสุด รับสินค้า : ${_dateFinal.toString()}');

  Map params = Map();
  params['orderId'] = orderData.orderId.toString();
  params['itemId'] = orderData.itemId.toString();
  params['marketId'] = orderData.marketId.toString();
  params['status'] = statusOrder.toString();
  params['userId'] = orderData.userId.toString();
  params['dealBegin'] = _dealBegin.toString();
  params['dealFinal'] = _dealFinal.toString();
  params['dateBegin'] = _dateBegin.toString();
  params['dateFinal'] = _dateFinal.toString();
  await http.post(Uri.parse(urlOrderUpdate), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res){
    print(res.body);
  });

}