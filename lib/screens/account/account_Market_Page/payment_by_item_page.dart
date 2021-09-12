import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentByItemId extends StatefulWidget {
  PaymentByItemId(this.token, this.itemID);

  final token;
  final int itemID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentByItemId(token, itemID);
  }
}

class _PaymentByItemId extends State {
  _PaymentByItemId(this.token, this.itemID);

  final token;
  final int itemID;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          'Item Id : ${itemID.toString()}',
          style: TextStyle(color: Colors.teal),
        ),
      ),
    );
  }
}
