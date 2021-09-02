import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentFormQRCode extends StatefulWidget{
  PaymentFormQRCode(this.paymentId);
  final paymentId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentFormQRCode(paymentId);
  }
}
class _PaymentFormQRCode extends State{
  _PaymentFormQRCode(this.paymentId);
  final paymentId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}