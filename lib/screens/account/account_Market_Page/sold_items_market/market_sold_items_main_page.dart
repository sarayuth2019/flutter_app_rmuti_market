import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/sold_items_market/market_overview.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/sold_items_market/market_sold_items_tab.dart';

class MarketSoldItemsMainPage extends StatefulWidget {
  MarketSoldItemsMainPage(this.token, this.marketId);

  final token;
  final marketId;

  @override
  _MarketSoldItemsMainPageState createState() =>
      _MarketSoldItemsMainPageState(token, marketId);
}

class _MarketSoldItemsMainPageState extends State<MarketSoldItemsMainPage> {
  _MarketSoldItemsMainPageState(this.token, this.marketId);

  final token;
  final marketId;

  String statusTab1 = 'รอตรวจสอบจากร้านค้า';
  String statusTab2 = 'ชำระเงินสำเร็จ';
  String statusTab3 = 'ชำระเงินผิดพลาด';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'บิลการโอนเงินค่าสินค้า',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MarketOverViewTab(token, marketId)));
                },
                child: Text(
                  'over view',
                  style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),
                ))
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.teal),
          bottom: TabBar(isScrollable: true, labelColor: Colors.teal, tabs: [
            Tab(text: '${statusTab1.toString()}'),
            Tab(text: '${statusTab2.toString()}'),
            Tab(text: '${statusTab3.toString()}'),
          ]),
        ),
        body: TabBarView(
          children: [
            MarketSoldItemsTab(token, marketId, statusTab1),
            MarketSoldItemsTab(token, marketId, statusTab2),
            MarketSoldItemsTab(token, marketId, statusTab3),
          ],
        ),
      ),
    );
  }
}
