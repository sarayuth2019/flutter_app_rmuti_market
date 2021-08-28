import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_tab.dart';

class PaymentMainPage extends StatefulWidget {
  PaymentMainPage(this.token);

  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentMain(token);
  }
}

class _PaymentMain extends State {
  _PaymentMain(this.token);

  final token;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.teal,
          tabs: [
            Tab(
              text: 'รอดำเนินการ',
            ),
            Tab(
              text: 'ชำระเงินสำเร็จ',
            ),
          ],
        ),
        body: TabBarView(
          children: [PaymentTab(token,'รอดำเนินการ'),PaymentTab(token,'ชำระเงินสำเร็จ')]
        ),
      ),
    );
  }
}
