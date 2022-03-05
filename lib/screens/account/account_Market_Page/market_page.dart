import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/edit_account/edit_account.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/sold_items_market/market_sold_items_main_page.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_page/data_for_payment_page/market__data_page/show_review_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_item_by_marketId.dart';
import 'package:flutter_app_rmuti_market/screens/method/review_market_method.dart';
import 'package:flutter_app_rmuti_market/screens/method/send_accountData.dart';
import 'package:flutter_app_rmuti_market/screens/sing_in_up/sing_in_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  final String urlGetPaymentByMarketId = '${Config.API_URL}/Pay/market';

  @override
  Widget build(BuildContext context) {
    print("Market ID : ${marketId.toString()}");
    // TODO: implement build
    return FutureBuilder(
      future: sendAccountDataByUser(token),
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshotMarketData) {
        if (snapshotMarketData.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal,
                elevation: 0,
                title: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MarketSoldItemsMainPage(
                                  token, marketId)));
                    },
                    icon: Icon(
                      Icons.monetization_on_outlined,
                      color: Colors.amber,
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
                mini: true,
                child: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAccount(
                              snapshotMarketData.data.marketData,
                              snapshotMarketData.data.imageMarket,
                              token)));
                },
              ),
              body: Column(
                children: [
                  SingleChildScrollView(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          child: Image.memory(
                            base64Decode(snapshotMarketData.data.imageMarket),
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
                                      "Market ID : ${snapshotMarketData.data.marketData.marketID}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "ชื่อร้าน : ${snapshotMarketData.data.marketData.nameMarket}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "ชื่อเจ้าของร้าน : ${snapshotMarketData.data.marketData.name} ${snapshotMarketData.data.marketData.surname}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "อีเมล : ${snapshotMarketData.data.marketData.email}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "เบอร์ติดต่อ : ${snapshotMarketData.data.marketData.phoneNumber}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "รายละเอียดที่อยู่ร้าน : ${snapshotMarketData.data.marketData.descriptionMarket}",
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
                                child: Text(
                                  'ยังไม่มีการรีวิวร้านค้า',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      RatingBar.builder(
                                          itemSize: 30,
                                          ignoreGestures: true,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          initialRating:
                                              _sumRating / _countRating,
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
                      future: listItemByUser(token, marketId),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
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
                                  child: Container(
                                    decoration: boxDecorationGrey,
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 3.0, left: 8.0, right: 8.0),
                                          child: Text(
                                            "${snapshot.data[index].nameItem}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Text(
                                            "ราคา ${snapshot.data[index].priceSell} บาท ลดราคาจาก ${snapshot.data[index].price} บาท",
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Text(
                                            "ต้องการขาย ${snapshot.data[index].countRequest} ลงทะเบียนซื้อแล้ว ${snapshot.data[index].count}",
                                          ),
                                        ),
                                      ],
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
      },
    );
  }

  Future logout() async {
    final SharedPreferences _dataID = await SharedPreferences.getInstance();
    _dataID.clear();
    print("account logout ! ${_dataID.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
}


