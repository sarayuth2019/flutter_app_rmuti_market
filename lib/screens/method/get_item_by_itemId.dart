import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart'as http;



Future<Items?> getItemByItemId(token, int itemId) async {
  final String urlGetItemByItemId = '${Config.API_URL}/Item/list/item';
  Items? itemData;
  Map params = Map();
  params['id'] = itemId.toString();
  await http.post(Uri.parse(urlGetItemByItemId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print("Get Item By Account Success");
    Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var _itemData = _jsonRes['data'];
    print(_itemData);
    Items _items = Items(
      _itemData['itemId'],
      _itemData['nameItems'],
      _itemData['groupItems'],
      _itemData['price'],
      _itemData['priceSell'],
      _itemData['count'],
      _itemData['size'],
      _itemData['colors'],
      _itemData['countRequest'],
      _itemData['marketId'],
      _itemData['dateBegin'],
      _itemData['dateFinal'],
      _itemData['dealBegin'],
      _itemData['dealFinal'],
      _itemData['createDate'],
    );
    itemData = _items;
  });
  //item = itemData;
  return itemData;
}
class Items {
  final int itemId;
  final String nameItem;
  final int groupItem;
  final int price;
  final int priceSell;
  final int count;
  final List size;
  final List color;
  final int countRequest;
  final int marketId;
  final String dateBegin;
  final String dateFinal;
  final String dealBegin;
  final String dealFinal;
  final String date;

  Items(
      this.itemId,
      this.nameItem,
      this.groupItem,
      this.price,
      this.priceSell,
      this.count,
      this.size,
      this.color,
      this.countRequest,
      this.marketId,
      this.dateBegin,
      this.dateFinal,
      this.dealBegin,
      this.dealFinal,
      this.date);
}