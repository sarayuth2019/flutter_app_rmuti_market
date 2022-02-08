
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter_app_rmuti_market/config/config.dart';

Future<void> getImage(token,itemId) async {
  final String urlGetImageByItemId = "${Config.API_URL}/images/";
  var _resData;
  await http.get(
      Uri.parse('${urlGetImageByItemId.toString()}${itemId.toString()}'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
      }).then((res) {
    //print(res.body);
    Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var _statusData = jsonData['status'];
    var _dataImage = jsonData['dataImages'];
    //var _dataId = jsonData['dataId'];
    if (_statusData == 1) {
      _resData = _dataImage;
      //print("jsonData : ${_resData.toString()}");
    }
  });
  //print("_resData ${_resData.toString()}");
  return _resData;
}