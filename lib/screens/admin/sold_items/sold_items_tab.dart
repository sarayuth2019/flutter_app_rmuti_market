import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/admin/sold_items/list_order_by_item/list_order_by_Item_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_items_for_admin.dart';

class SoldItemsTab extends StatefulWidget {
  SoldItemsTab(this.token, this.adminId, this.url);

  final token;
  final adminId;
  final String url;

  @override
  _SoldItemsTabState createState() => _SoldItemsTabState(token, adminId, url);
}

class _SoldItemsTabState extends State<SoldItemsTab> {
  _SoldItemsTabState(this.token, this.adminId, this.url);

  final token;
  final adminId;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: listItemsForAdmin(token, url),
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshotItemData) {
          if (snapshotItemData.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshotItemData.data.length == 0) {
            return Center(
              child: Text(
                'ไม่มีรายการ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshotItemData.data.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ListOrderByItemPage(token, adminId,
                                        snapshotItemData.data[index])));
                      },
                      child: Container(
                          decoration: boxDecorationGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${snapshotItemData.data[index].itemId} : ${snapshotItemData.data[index].nameItem}'),
                                Row(
                                  children: [
                                    Text(
                                        'จำนวนผู้ลงทะเบียน : ${snapshotItemData.data[index].count}/${snapshotItemData.data[index].countRequest}')
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
