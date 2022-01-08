import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

Future<List<Payment>> listAllPaymentData(token) async {
  final String urlGetAllPayment = '${Config.API_URL}/Pay/list';
  List<Payment> listPaymentOverview = [];
  List<Payment> listAllPayment = [];
  await http.get(Uri.parse(urlGetAllPayment), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    //print(jsonData);
    var payData = jsonData['data'];
    for (var i in payData) {
      Payment _payment = Payment(
          i['payId'],
          i['status'],
          i['userId'],
          i['orderId'],
          i['marketId'],
          i['detail'],
          i['amount'],
          i['lastNumber'],
          i['bankTransfer'],
          i['bankReceive'],
          i['date'],
          i['time'],
          i['dataTransfer']);
      listAllPayment.add(_payment);
    }
    List<Payment> listStatus1 = listAllPayment
        .where(
            (element) => element.status.toString().contains('ชำระเงินสำเร็จ'))
        .toList();
    List<Payment> listStatus2 = listAllPayment
        .where(
            (element) => element.status.toString().contains('รับสินค้าสำเร็จ'))
        .toList();
    List<Payment> listStatus3 = listAllPayment
        .where((element) => element.status.toString().contains('รีวิวสำเร็จ'))
        .toList();
    listPaymentOverview = listStatus1 + listStatus2 + listStatus3;
  });
  return listPaymentOverview;
}

class Payment {
  final int payId;
  final String status;
  final int userId;
  final int orderId;
  final int marketId;
  final detail;
  final int amount;
  final int lastNumber;
  final String bankTransfer;
  final String bankReceive;
  final String date;
  final String time;
  final String dataTransfer;

  Payment(
      this.payId,
      this.status,
      this.userId,
      this.orderId,
      this.marketId,
      this.detail,
      this.amount,
      this.lastNumber,
      this.bankTransfer,
      this.bankReceive,
      this.date,
      this.time,
      this.dataTransfer);
}
