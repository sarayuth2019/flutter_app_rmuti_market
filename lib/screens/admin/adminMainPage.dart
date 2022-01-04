import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/admin/overview_order/admin_overview_tab.dart';
import 'package:flutter_app_rmuti_market/screens/admin/payment/payment_tab.dart';
import 'package:flutter_app_rmuti_market/screens/admin/search_payment/search_payment_tab.dart';
import 'package:flutter_app_rmuti_market/screens/sing_in_up/sing_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMainPage extends StatefulWidget {
  AdminMainPage(this.token, this.marketId);

  final token;
  final marketId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdminMainPage(token, marketId);
  }
}

class _AdminMainPage extends State {
  _AdminMainPage(this.token, this.marketId);

  final token;
  final marketId;
  PageController _pageController = PageController();
  int tabNum = 0;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SingIn()),
                    (route) => false);
              },
              child: Text(
                'logout',
                style: TextStyle(color: Colors.teal),
              ))
        ],
        title: Text(
          'Admin Page',
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [PaymentTab(token, 'รอดำเนินการ'), SearchPayment(token),AdminOverViewTab(token)],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        currentIndex: tabNum,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            tabNum = index;
            pageChanged(index);
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Payment"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Search Payment"),
          BottomNavigationBarItem(
              icon: Icon(Icons.table_view_outlined), label: "Over View"),
        ],
      ),
    );
  }

  void pageChanged(int numPageView) {
    _pageController.jumpToPage(numPageView);
    setState(() {
      tabNum = numPageView;
      print(tabNum);
    });
  }
  Future logout() async {
    final SharedPreferences _tokenIDInDevice = await SharedPreferences.getInstance();
    _tokenIDInDevice.clear();
    print("account logout ! ${_tokenIDInDevice.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
}
