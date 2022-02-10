import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_Image_payment_admin.dart';
import 'package:http/http.dart' as http;

void saveStatusPaymentAdmin(
    context,
    token,
    paymentAdminData,
    adminId,
    detail,
    bankTransfer,
    bankReceive,
    date,
    time,
    amount,
    listNumber,
    statusPaymentAdmin,
    imageFile) async {
  print('Save PaymentAdminData ..........................');
  String urlSavePaymentAdmin = '${Config.API_URL}/PayAdmin/update';
  Map params = Map();
  params['payId'] = paymentAdminData.payId.toString();
  params['adminId'] = adminId.toString();
  params['marketId'] = paymentAdminData.marketId.toString();
  params['itemId'] = paymentAdminData.itemId.toString();
  params['detail'] = detail.toString();
  params['bankTransfer'] = bankTransfer.toString();
  params['bankReceive'] = bankReceive.toString();
  params['date'] = date.toString();
  params['time'] = time.toString();
  params['amount'] = amount.toString();
  params['lastNumber'] = listNumber.toString();
  params['status'] = statusPaymentAdmin.toString();
  await http.post(Uri.parse(urlSavePaymentAdmin), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print(
        '=====================================>   Save Status Payment Admin !!!');
    print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var status = resData['status'];
    if (status == 1) {
      saveImagePaymentAdmin(context, token, paymentAdminData.payId, imageFile);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('บันทึกการโอนเงิน ผิดพลาด')));
    }
  });
}
