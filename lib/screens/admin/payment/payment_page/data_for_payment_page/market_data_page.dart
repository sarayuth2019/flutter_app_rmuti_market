import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketDataPage extends StatefulWidget {
  MarketDataPage(this.token, this.marketId);

  final token;
  final int marketId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MarketDataPage(token, marketId);
  }
}

class _MarketDataPage extends State {
  _MarketDataPage(this.token, this.marketId);

  final token;
  final int marketId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Market Id : ${marketId.toString()}'),
      ),
    );
  }
}
