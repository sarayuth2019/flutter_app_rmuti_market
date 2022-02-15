import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart'as http;

class MarketDataObject{
  MarketDataObject(this.marketData, this.imageMarket);
  final MarketData marketData;
  final imageMarket;
}


Future<MarketDataObject?> sendAccountDataByUser(token) async {
  MarketDataObject? marketDataObject;
  var _imageMarket;
  var _marketAccountData;
  final String urlSendAccountById = "${Config.API_URL}/Market/list";
  await http.post(Uri.parse(urlSendAccountById), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    //print(res.body);
    print("Send Market Data...");
    Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var _dataAccount = _jsonRes['dataId'];
    _imageMarket = _jsonRes['dataImages'];
    print(_dataAccount);
    print("data Market : ${_dataAccount.toString()}");
    print(_dataAccount);

    _marketAccountData = MarketData(
      _dataAccount['marketId'],
      _dataAccount['password'],
      _dataAccount['name'],
      _dataAccount['surname'],
      _dataAccount['email'],
      _dataAccount['statusMarket'],
      _dataAccount['imageMarket'],
      _dataAccount['phoneNumber'],
      _dataAccount['nameMarket'],
      _dataAccount['descriptionMarket'],
      _dataAccount['dateRegister'],
    );
    marketDataObject = MarketDataObject(_marketAccountData, _imageMarket);
    print("market data : ${marketDataObject!.marketData}");
  });
  return marketDataObject;
}


class MarketData {
  final int? marketID;
  final String? password;
  final String? name;
  final String? surname;
  final String? email;
  final String? statusMarket;
  final String? imageMarket;
  final String? phoneNumber;
  final String? nameMarket;
  final String? descriptionMarket;
  final String? dateRegister;

  MarketData(
      this.marketID,
      this.password,
      this.name,
      this.surname,
      this.email,
      this.statusMarket,
      this.imageMarket,
      this.phoneNumber,
      this.nameMarket,
      this.descriptionMarket,
      this.dateRegister);
}