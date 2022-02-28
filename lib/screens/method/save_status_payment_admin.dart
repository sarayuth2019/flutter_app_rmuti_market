import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_Image_payment_admin.dart';
import 'package:http/http.dart' as http;

void marketSaveStatusPaymentAdmin(
    context, token, paymentAdminData, status, detail) async {
  print(
      '=====================================>  Market Save Status Payment Admin ${status.toString()}!!!');
  String _time =
      '${paymentAdminData.time.split(':')[0]}:${paymentAdminData.time.split(':')[1]}';
  String _date =
      '${paymentAdminData.date.split('/')[1]}/${paymentAdminData.date.split('/')[0]}/${paymentAdminData.date.split('/')[2]}';
  print(_time);
  print(_date);

  saveStatusPaymentAdmin(
      context,
      token,
      paymentAdminData,
      paymentAdminData.adminId,
      detail,
      paymentAdminData.bankTransfer,
      paymentAdminData.bankReceive,
      _date,
      _time,
      paymentAdminData.amount,
      status,
      null);
  Navigator.pop(context);
}

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
    statusPaymentAdmin,
    imageFile) async {
  print('Save PaymentAdminData ..........................');
  String urlSavePaymentAdmin =
      '${Config.API_URL}/PayAdmin/update/${paymentAdminData.payId}';
  Map params = Map();
  params['payId'] = paymentAdminData.payId.toString();
  params['adminId'] = adminId.toString();
  params['marketId'] = paymentAdminData.marketId.toString();
  params['itemId'] = paymentAdminData.itemId.toString();
  params['detail'] = detail.toString();
  params['bankTransfer'] = bankTransfer.toString();
  params['bankReceive'] = bankReceive.toString();
  params['date'] = date.toString();
  params['time'] = '${time.toString()}:00'.toString();
  params['amount'] = amount.toString();
  //params['lastNumber'] = listNumber.toString();
  params['status'] = statusPaymentAdmin.toString();
  await http.post(Uri.parse(urlSavePaymentAdmin), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print(
        '=====================================>  Save Status Payment Admin ${statusPaymentAdmin.toString()}!!!');
    print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var status = resData['status'];
    if (status == 1) {
      if (imageFile == null) {
        print('No have Image payment ');
      } else {
        saveImagePaymentAdmin(
            context, token, paymentAdminData.payId, imageFile);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('บันทึกการโอนเงิน ผิดพลาด')));
    }
  });
}
