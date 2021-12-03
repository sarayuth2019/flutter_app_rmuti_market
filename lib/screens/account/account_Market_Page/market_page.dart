import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/edit_account.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/payment_of_item_page.dart';
import 'package:flutter_app_rmuti_market/screens/account/my_shop_tab/my_shop_tab.dart';
import 'package:flutter_app_rmuti_market/screens/account/scanner_qr_code/scan_qr_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/market__data_page/show_review_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/review_market_method.dart';
import 'package:flutter_app_rmuti_market/screens/sing_in_up/sing_in_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MarketPage extends StatefulWidget {
  MarketPage(this.token, this.marketId);

  final token;
  final marketId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MarketPage(token, marketId);
  }
}

class _MarketPage extends State {
  _MarketPage(this.token, this.marketId);

  final token;
  final marketId;

  final String urlSendAccountById = "${Config.API_URL}/Market/list";
  final String urlGetPaymentByMarketId = '${Config.API_URL}/Pay/market';
  final urlListItemByMarketId = "${Config.API_URL}/Item/find/market";
  MarketData? _marketAccountData;
  var _imageMarket;

  @override
  Widget build(BuildContext context) {
    print("Market ID : ${marketId.toString()}");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScannerQRCode(token)));
              },
              icon: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              )),
          actions: [
            TextButton(
                onPressed: logout,
                child: Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditAccount(_marketAccountData, _imageMarket, token)));
          },
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: sendAccountDataByUser(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  print('Account snapshotData : ${snapshot.data}');
                  return Center(child: CircularProgressIndicator());
                } else {
                  return SingleChildScrollView(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          child: Image.memory(
                            base64Decode(_imageMarket),
                            fit: BoxFit.fill,
                          ),
                          color: Colors.blueGrey,
                          height: 250,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Opacity(
                          opacity: 0.80,
                          child: Card(
                            child: Container(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Market ID : ${snapshot.data.marketID}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "ชื่อร้าน : ${snapshot.data.nameMarket}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "ชื่อเจ้าของร้าน : ${snapshot.data.name} ${snapshot.data.surname}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "อีเมล : ${snapshot.data.email}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "เบอร์ติดต่อ : ${snapshot.data.phoneNumber}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "รายละเอียดที่อยู่ร้าน : ${snapshot.data.descriptionMarket}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            FutureBuilder(
              future: listReviewByMarketId(token, marketId),
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshotReview) {
                print('snapshotReview : ${snapshotReview.data}');
                if (snapshotReview.data == null) {
                  return Text('กำลังโหลด...');
                } else if (snapshotReview.data.length == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: double.infinity,
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('ยังไม่มีการรีวิวร้านค้า',style: TextStyle(fontWeight: FontWeight.bold),),
                        )),
                  );
                } else {
                  var _sumRating = snapshotReview.data
                      .map((r) => r.rating)
                      .reduce((value, element) => value + element);
                  var _countRating = snapshotReview.data.length;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowReviewPage(
                                    snapshotReview.data,
                                    (_sumRating / _countRating),
                                    _countRating)));
                      },
                      child: Container(
                          decoration: boxDecorationGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'รีวิวของทางร้าน : ${(_sumRating / _countRating).toStringAsFixed(1)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                RatingBar.builder(
                                    itemSize: 30,
                                    ignoreGestures: true,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    initialRating: _sumRating / _countRating,
                                    itemBuilder: (context, r) {
                                      return Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                      );
                                    },
                                    onRatingUpdate: (value) {}),
                              ],
                            ),
                          )),
                    ),
                  );
                }
              },
            ),
            Text(
              'ประวัติการขาย',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder(
                future: listItemByUser(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data.length == 0) {
                    return Center(
                      child: Text(
                        'ไม่มีประวัติการขาย',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaymentOfItemId(
                                            token,
                                            snapshot.data[index].itemID)));
                              },
                              child: Container(
                                decoration: boxDecorationGrey,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, left: 8.0, right: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${snapshot.data[index].nameItem}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "ราคา ${snapshot.data[index].priceSell} จาก ${snapshot.data[index].price} ต้องการลงชื่อ ${snapshot.data[index].countRequest} มีคนลงแล้ว ${snapshot.data[index].count}",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            "รวมเป็นเงิน : ${(snapshot.data[index].priceSell) * snapshot.data[index].count} บาท",
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ));
  }

  Future<MarketData> sendAccountDataByUser() async {
    await http.post(Uri.parse(urlSendAccountById), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);
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
      print("market data : ${_marketAccountData}");
    });
    return _marketAccountData!;
  }

  Future<List<Item>> listItemByUser() async {
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

  Future logout() async {
    final SharedPreferences _dataID = await SharedPreferences.getInstance();
    _dataID.clear();
    print("account logout ! ${_dataID.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
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
