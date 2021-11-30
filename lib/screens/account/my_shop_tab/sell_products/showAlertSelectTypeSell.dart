import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/account/my_shop_tab/sell_products/sell_products_tab.dart';

void showAlertSelectType1(BuildContext context, token, marketId) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ประเภทของสินค้า',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: GestureDetector(
                        child: Text('สินค้า พร้อมขาย'),
                        onTap: () {
                          var typeItemSell = 1;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellProducts(
                                      token, marketId, typeItemSell)));
                        })),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: GestureDetector(
                        child: Text('สินค้า Pre order'),
                        onTap: () {
                          var typeItemSell = 2;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellProducts(
                                      token, marketId, typeItemSell)));
                        })),
              ],
            ),
          ),
        );
      });
}
