import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

Future<PaymentAdmin?> getPaymentAdminByItemId(token, itemId) async {
  String urlGetPaymentAdminByItemId = '${Config.API_URL}/PayAdmin/listByItemId';
  Map params = Map();
  PaymentAdmin? paymentAdminData;
  params['itemId'] = itemId.toString();
  await http.post(Uri.parse(urlGetPaymentAdminByItemId),
      body: params,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
      }).then((res) {
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var _paymentData = resData['data'];
    var paymentData = _paymentData[0];
    //print(paymentData);
    paymentAdminData = PaymentAdmin(
        paymentData['payId'],
        paymentData['status'],
        paymentData['adminId'],
        paymentData['marketId'],
        paymentData['itemId'],
        paymentData['detail'],
        paymentData['amount'],
        paymentData['bankTransfer'],
        paymentData['bankReceive'],
        paymentData['date'],
        paymentData['time'],
        paymentData['dataTransfer']);
    //print(paymentAdminData);
  });
  return paymentAdminData;
}

class PaymentAdmin {
  PaymentAdmin(
      this.payId,
      this.status,
      this.adminId,
      this.marketId,
      this.itemId,
      this.detail,
      this.amount,
      this.bankTransfer,
      this.bankReceive,
      this.date,
      this.time,
      this.dataTransfer);

  final int payId;
  final String status;
  final int adminId;
  final int marketId;
  final int itemId;
  final String detail;
  final amount;
  final String bankTransfer;
  final String bankReceive;
  final date;
  final time;
  final dataTransfer;
}
