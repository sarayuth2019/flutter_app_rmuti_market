import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rmuti_market/screens/method/get_item_by_itemId.dart';
import 'package:http/http.dart' as http;

Future<List<Items>> listItemsForAdmin(token,String urlApi) async {
  List<Items> listItemsForAdmin = [];
  await http.get(Uri.parse(urlApi), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    //print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var _listDataItems = resData['data'];
    for(var i in _listDataItems){
      Items _item = Items(
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
      listItemsForAdmin.add(_item);
    }
  });
  return listItemsForAdmin;
}
