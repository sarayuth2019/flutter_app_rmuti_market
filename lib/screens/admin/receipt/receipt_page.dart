import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReceiptPage extends StatefulWidget{
  ReceiptPage(this.token);
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReceiptPage(token);
  }
}
class _ReceiptPage extends State{
  _ReceiptPage(this.token);
  final token;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(backgroundColor: Colors.amber,);
  }
}