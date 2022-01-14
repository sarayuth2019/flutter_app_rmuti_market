import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/market_page.dart';
import 'package:flutter_app_rmuti_market/screens/account/my_shop_tab/my_shop_tab.dart';
import 'package:flutter_app_rmuti_market/screens/account/notify/notify_page.dart';
import 'package:flutter_app_rmuti_market/screens/account/scanner_qr_code/scan_qr_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_notifyMarket.dart';
import 'package:flutter_app_rmuti_market/screens/sing_in_up/sing_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SingIn()));

class HomePage extends StatefulWidget {
  HomePage(this.token, this.marketId);

  final token;
  final marketId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage(token, marketId);
  }
}

class _HomePage extends State {
  _HomePage(this.token, this.marketId);

  final token;
  final marketId;

  final testSnackBar = SnackBar(content: Text("เทสๆสแนคบา"));
  PageController _pageController = PageController();
  int tabNum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Market account ID : ${token.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          MyShop(token, marketId),
          NotifyPage(token, marketId, callBack),
          MarketPage(token, marketId),
          ScannerQRCode(token)
        ],
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
              icon: Icon(Icons.add_business), label: "My Shop"),
          BottomNavigationBarItem(
              icon: iconNavigationBar(Icon(Icons.notifications_active),
                  listNotifyMarket(token, marketId)),
              label: "Notification"),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: "Market"),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: "Scan QR")
        ],
      ),
    );
  }

  Widget iconNavigationBar(Widget icon, var listCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        FutureBuilder(
          future: listCount,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null || snapshot.data.length == 0) {
              return Container(
                width: 10,
                height: 10,
              );
            } else {
              return Positioned(
                  top: -6,
                  right: -18,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${snapshot.data.length.toString()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ));
            }
          },
        )
      ],
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
    final SharedPreferences _tokenIDInDevice =
        await SharedPreferences.getInstance();
    _tokenIDInDevice.clear();
    print("account logout ! ${_tokenIDInDevice.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }

  void callBack() {
    setState(() {
      print('SetState HomePage !!!!!!!!!!!!!!');
    });
  }
}

