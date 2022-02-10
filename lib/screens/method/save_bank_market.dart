import 'dart:convert';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

void saveBankMarket(
  int marketId,
  String bankName,
  bankNumber,
  String bankAccountName,
) async {
  print('marketId : ${marketId.toString()}');
  print('bankName : ${bankName.toString()}');
  print('bankNumber : ${bankNumber.toString()}');
  print('bankAccountName : ${bankAccountName.toString()}');

  String urlSaveBankMarket = '${Config.API_URL}/BankMarket/save';
  Map params = Map();
  params['marketId'] = marketId.toString();
  params['nameBank'] = bankName.toString();
  params['bankNumber'] = bankNumber.toString();
  params['bankAccountName'] = bankAccountName.toString();

  await http.post(Uri.parse(urlSaveBankMarket), body: params).then((res) {
    print(res.body);
    final resData =  jsonDecode(res.body);
    var status = resData['status'];
    if (status == 1) {
      //print(data);
    } else {
      print('Save BankMarket Fall !!!!!!');
    }
  });
}
