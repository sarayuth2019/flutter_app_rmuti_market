import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_page.dart';
import 'package:flutter_app_rmuti_market/screens/my_order_tab/my_order_tab.dart';
import 'package:flutter_app_rmuti_market/screens/my_shop_tab/my_shop_tab.dart';
import 'package:flutter_app_rmuti_market/screens/account/sing_in_page.dart';
import 'package:flutter_app_rmuti_market/screens/account/sing_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SingIn()));

class HomePage extends StatefulWidget {
  HomePage(this.accountID);

  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage(accountID);
  }
}

class _HomePage extends State {
  _HomePage(this.accountID);

  final int accountID;

  final testSnackBar = SnackBar(content: Text("เทสๆสแนคบา"));
  PageController _pageController = PageController();
  int tabNum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Market account ID : ${accountID.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          MyShop(accountID),
          MyOrderTab(accountID),
          AccountPage(accountID)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active), label: "Notification"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
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
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    _accountID.clear();
    print("account logout ! ${_accountID.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
}
