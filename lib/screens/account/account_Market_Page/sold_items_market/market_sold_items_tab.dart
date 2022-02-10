import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/sold_items_market/show_payment_admin_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_admin_by_marketId_andStatus.dart';

class MarketSoldItemsTab extends StatefulWidget {
  MarketSoldItemsTab(this.token, this.marketId, this.status);

  final token;
  final marketId;
  final status;

  @override
  _MarketSoldItemsTabState createState() =>
      _MarketSoldItemsTabState(token, marketId, status);
}

class _MarketSoldItemsTabState extends State<MarketSoldItemsTab> {
  _MarketSoldItemsTabState(this.token, this.marketId, this.status);

  final token;
  final marketId;
  final status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: listPaymentAdminByMarketIdAndStatus(token, marketId, status),
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshotPaymentAdmin) {
        if (snapshotPaymentAdmin.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: snapshotPaymentAdmin.data.length,
              itemBuilder: (BuildContext context, index) {
                return Card(
                    child: ListTile(
                        title: Text(
                          'รายการของ ItemId : ${snapshotPaymentAdmin.data[index].itemId}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'จำนวนเงิน : ${snapshotPaymentAdmin.data[index].amount} บาท'),
                            Text(
                                'ธนาคารที่โอน : ${snapshotPaymentAdmin.data[index].bankTransfer}'),
                            Text(
                                'ธนาคารที่รับ : ${snapshotPaymentAdmin.data[index].bankReceive}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 120,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.teal),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowPaymentAdminPage(
                                                          token,
                                                          snapshotPaymentAdmin
                                                              .data[index])));
                                        },
                                        child: Text('ตรวจสอบ'))),
                              ],
                            )
                          ],
                        )));
              });
        }
      },
    ));
  }
}
