import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/admin/sold_items/sold_items_tab.dart';

class SoldItemsMainTab extends StatefulWidget {
  SoldItemsMainTab(this.token, this.adminId);

  final token;
  final adminId;

  @override
  _SoldItemsMainTabState createState() =>
      _SoldItemsMainTabState(token, adminId);
}

class _SoldItemsMainTabState extends State<SoldItemsMainTab> {
  _SoldItemsMainTabState(this.token, this.adminId);

  final token;
  final adminId;

  String urlListItemsPendingForAdmin = '${Config.API_URL}/PayAdmin/listPending';
  String urlListItemsSuccessForAdmin =
      '${Config.API_URL}/PayAdmin/listPaymentSuccess';
  String urlListItemsFailForAdmin =
      '${Config.API_URL}/PayAdmin/listPaymentFail';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: TabBar(labelColor: Colors.teal, tabs: [
          Tab(text: 'รอดำเนินการ'),
          Tab(text: 'โอนเงินสำเร็จ'),
          Tab(text: 'โอนเงินผิดพลาด'),
        ]),
        body: TabBarView(
          children: [
            SoldItemsTab(token, adminId, urlListItemsPendingForAdmin),
            SoldItemsTab(token, adminId, urlListItemsSuccessForAdmin),
            SoldItemsTab(token, adminId, urlListItemsFailForAdmin),
          ],
        ),
      ),
    );
  }
}
