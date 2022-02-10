import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_admin_by_itemId.dart';
import 'package:http/http.dart' as http;

Future<List<PaymentAdmin>> listPaymentAdminByMarketIdAndStatus(
    token, marketId, status) async {
  String urlListPaymentAdminByMarketIdAndStatus =
      '${Config.API_URL}/Market/listMarketByStatusPayAdmin';
  List<PaymentAdmin> listPaymentAdminByMarketIdAndStatus = [];
  Map params = Map();
  params['marketId'] = marketId.toString();
  params['status'] = status.toString();
  await http.post(Uri.parse(urlListPaymentAdminByMarketIdAndStatus),
      body: params,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
      }).then((res) {
    //print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var listData = resData['data'];
    for (var i in listData) {
      PaymentAdmin _paymentAdmin = PaymentAdmin(
          i['payId'],
          i['status'],
          i['adminId'],
          i['marketId'],
          i['itemId'],
          i['detail'],
          i['amount'],
          i['bankTransfer'],
          i['bankReceive'],
          i['date'],
          i['time'],
          i['dataTransfer']);
      listPaymentAdminByMarketIdAndStatus.add(_paymentAdmin);
    }
  });

  return listPaymentAdminByMarketIdAndStatus;
}
