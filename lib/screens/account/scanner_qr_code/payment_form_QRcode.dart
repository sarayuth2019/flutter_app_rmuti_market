import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentFormQRCode extends StatefulWidget{
  PaymentFormQRCode(this.token,this.paymentId);
  final token;
  final paymentId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentFormQRCode(token,paymentId);
  }
}
class _PaymentFormQRCode extends State{
  _PaymentFormQRCode(this.token,this.paymentId);
  final token;
  final paymentId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(child: Text('Payment Id : ${paymentId.toString()}')),
    );
  }
}