
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/my_shop_tab/my_shop_tab.dart';
import 'package:http/http.dart'as http;



Future<List<Item>> listItemByUser(token,int marketId) async {
  final urlListItemByMarketId = "${Config.API_URL}/Item/find/market";
  Map params = Map();
  List<Item> listItemSell = [];
  params['market'] = marketId.toString();
  await http.post(Uri.parse(urlListItemByMarketId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print("listItem By Account Success");
    Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var _itemData = _jsonRes['data'];

    for (var i in _itemData) {
      Item _items = Item(
        i['itemId'],
        i['nameItems'],
        i['groupItems'],
        i['price'],
        i['priceSell'],
        i['count'],
        i['size'],
        i['colors'],
        i['countRequest'],
        i['marketId'],
        i['dateBegin'],
        i['dateFinal'],
        i['dealBegin'],
        i['dealFinal'],
        i['createDate'],
      );
      if (_items.count == _items.countRequest) {
        listItemSell.add(_items);
      }
    }

    /*listItemSell = listItem
          .where((element) =>
          element.count.toLowerCase().contains(status.toLowerCase()))
          .toList();

       */
  });
  print("Products By Account : ${listItemSell.length}");
  return listItemSell;
}