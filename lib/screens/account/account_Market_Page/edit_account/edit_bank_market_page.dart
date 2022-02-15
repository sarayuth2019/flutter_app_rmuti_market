import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/delete_bank_market.dart';
import 'package:flutter_app_rmuti_market/screens/method/edit_bank_market.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_bankmarket.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_bank_market.dart';
import 'package:flutter_app_rmuti_market/screens/method/send_accountData.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        mini: true,
        onPressed: () {
          showAddBankMarket(context, marketData,reFresh);
        },
        child: Icon(Icons.add),
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
              listBankMarketData = snapshotListBankMarket.data;
              return ListView.builder(
                shrinkWrap: true,
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
                        child: Column(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('เลขบัญชี : '),
                                Text('${listBankMarketData[index].bankNumber}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.amber[600]),
                                    onPressed: () {
                                      showDialogEditBankMarket(context, token,
                                          listBankMarketData[index],reFresh);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text('แก้ไขบัญชี'),
                                      ],
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () {
                                      print(
                                          'listBankMarket.length : ${listBankMarketData.length}');
                                      if (listBankMarketData.length == 1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'ต้องมีบัญชีธนาคารอย่างน้อย 1 บัญชี !')));
                                      } else {
                                        showDialogDeleteBankMarket(
                                          context,
                                          token,
                                          listBankMarketData[index]
                                              .bankMarketId,reFresh
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.highlight_remove,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text('ลบบัญชี'),
                                      ],
                                    )),
                              ],
                            ),
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
