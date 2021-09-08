import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;

class NotifyPage extends StatefulWidget {
  NotifyPage(this.token, this.marketId);

  final token;
  final int marketId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotifyPage(token, marketId);
  }
}

class _NotifyPage extends State {
  _NotifyPage(this.token, this.marketId);

  final token;
  final int marketId;

  final String urlListNotifyByMarketId =
      '${Config.API_URL}/MarketNotify/list/market';
  final String urlClearAllNotifyByMarketId =
      '${Config.API_URL}/MarketNotify/deleteByMarketId';
  final String urlDeleteNotifyByNotifyId =
      '${Config.API_URL}/MarketNotify/deleteId';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: clearAll,
              child: Text(
                'clear all',
                style: TextStyle(color: Colors.teal),
              ))
        ],
      ),
      body: FutureBuilder(
        future: listNotify(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return Center(
                child: Text(
              'ไม่มีรายการแจ้งเตือน',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ));
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8),
                      child: Stack(
                        children: [
                          Container(
                            decoration: boxDecorationGrey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Id : ${snapshot.data[index].payId}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${snapshot.data[index].status.split(" ")[0]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                          child: snapshot.data[index].amount == 0
                                              ? Container()
                                              : Text(
                                                  'จำนวนเงิน : ${snapshot.data[index].amount} บาท'))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('${snapshot.data[index].createDate}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  onDeleteNotifyByNotifyId(
                                      snapshot.data[index].notifyId);
                                },
                                icon: Icon(
                                  Icons.highlight_remove,
                                  color: Colors.red,
                                ),
                              ))
                        ],
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      listNotify();
    });
  }

  void onDeleteNotifyByNotifyId(int notifyId) async {
    await http.get(
        Uri.parse(
            '${urlDeleteNotifyByNotifyId.toString()}/${notifyId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res){
          setState(() {
            print(res.body);
          });
    });
  }

  void clearAll() async {
    await http.get(
        Uri.parse(
            '${urlClearAllNotifyByMarketId.toString()}/${marketId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      setState(() {
        print(res.body);
      });
    });
  }

  Future<List<_Notify>> listNotify() async {
    List<_Notify> listNotify = [];
    Map params = Map();
    params['marketId'] = marketId.toString();
    await http.post(Uri.parse(urlListNotifyByMarketId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      var resData = jsonData['data'];
      for (var i in resData) {
        _Notify _notify = _Notify(i['notifyId'], i['amount'], i['status'],
            i['marketId'], i['payId'], i['createDate']);
        listNotify.insert(0, _notify);
      }
    });
    return listNotify;
  }
}

class _Notify {
  final int notifyId;
  final int amount;
  final String status;
  final int marketId;
  final int payId;
  final String createDate;

  _Notify(this.notifyId, this.amount, this.status, this.marketId, this.payId,
      this.createDate);
}