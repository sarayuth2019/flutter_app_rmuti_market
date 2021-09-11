import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart'as http;

Future<void> getImagePayment(token,int payId) async {
  final String urlGetPayImage = '${Config.API_URL}/ImagePay/listId';
  var imagePay;
  Map params = Map();
  params['payId'] = payId.toString();
  await http.post(Uri.parse(urlGetPayImage), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    var imagePayData = jsonData['dataImages'];
    imagePay = imagePayData;
  });
  return imagePay;
}