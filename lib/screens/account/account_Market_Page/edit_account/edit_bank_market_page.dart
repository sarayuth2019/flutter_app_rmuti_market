import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/market_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/edit_bank_market.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_bankmarket.dart';

class EditBankMarketPage extends StatefulWidget {
  EditBankMarketPage(this.token, this.marketData);

  final token;
  final marketData;

  @override
  _EditBankMarketPageState createState() =>
      _EditBankMarketPageState(token, marketData);
}

class _EditBankMarketPageState extends State<EditBankMarketPage> {
  _EditBankMarketPageState(this.token, this.marketData);

  final token;
  final MarketData marketData;

  List<BankMarket> listBankMarketData = [];

  Future<void> reFresh() async {
    Future.delayed(Duration(seconds: 5));
    setState(() {
      listBankMarket(token, marketData.marketID).then((value) {
        listBankMarketData = value;
        print(listBankMarketData);
        print('refresh Page !!!!!');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          "ข้อมูลธนาคาร",
          style: TextStyle(color: Colors.teal),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: reFresh,
        child: FutureBuilder(
          future: listBankMarket(token, marketData.marketID),
          builder: (BuildContext context,
              AsyncSnapshot<dynamic> snapshotListBankMarket) {
            if (snapshotListBankMarket.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              listBankMarketData.addAll(snapshotListBankMarket.data);
              return ListView.builder(
                itemCount: snapshotListBankMarket.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: boxDecorationGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'ธนาคาร : ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${listBankMarketData[index].nameBank}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('ชื่อบัญชี : '),
                                    Text(
                                      '${listBankMarketData[index].bankAccountName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('เลขบัญชี : '),
                                    Text(
                                        '${listBankMarketData[index].bankNumber}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              width: MediaQuery.of(context).size.width * 1.7,
                              child: IconButton(
                                  onPressed: () {
                                    showDialogEditBankMarket(context, token,
                                        listBankMarketData[index]);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.amber,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
