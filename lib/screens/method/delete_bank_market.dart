import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

void showDialogDeleteBankMarket(context, token, bankMarketId) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ลบบัญชีธนาคารนี้'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: () {
                    deleteBankMarket(context, token, bankMarketId);
                  },
                  child: Text('ยืนยัน')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('กลับ'))
            ],
          ),
        );
      });
}

void deleteBankMarket(context, token, bankMarketId) async {
  String urlDeleteBankMarket =
      '${Config.API_URL}/BankMarket/deleteByBankMarketId';
  Map params = Map();
  params['bankMarketId'] = bankMarketId.toString();
  await http.post(Uri.parse(urlDeleteBankMarket), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print(res.body);
    var resData = jsonDecode(res.body);
    var status = resData['status'];
    if (status == 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ลบบัญชี สำเร็จ')));
      Navigator.pop(context);
    } else {
      print(res.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ลบบัญชี ผิดพลาด')));
    }
  });
}
