import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

void savePaymentAdmin(token, adminId, marketId,itemId, detail) async {
  String urlSavePaymentAdmin = '${Config.API_URL}/PayAdmin/save';
  String statusPayment = 'รอดำเนินการ';
  Map params = Map();
  //params['payId'] = _paymentData.payId.toString();
  params['adminId'] = adminId.toString();
  params['marketId'] = marketId.toString();
  params['itemId'] = itemId.toString();
  params['detail'] = detail.toString();
  params['bankTransfer'] = 'รอดำเนินการ'.toString();
  params['bankReceive'] = 'รอดำเนินการ'.toString();
  params['date'] = '12/31/2022'.toString();
  params['time'] = '00:00:00'.toString();
  params['amount'] = '0'.toString();
  //params['lastNumber'] = '0000'.toString();
  params['status'] = statusPayment.toString();
  await http.post(Uri.parse(urlSavePaymentAdmin), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print('=====================================>   Save Payment Admin !!!');
    print(res.body);
    //var resData = jsonDecode(utf8.decode(res.bodyBytes));
  });
}
