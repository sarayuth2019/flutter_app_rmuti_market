import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllUserPage extends StatefulWidget{
  AllUserPage(this.token);
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AllUserPage(token);
  }
}
class _AllUserPage extends State{
  _AllUserPage(this.token);
  final token;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(backgroundColor: Colors.indigoAccent,);
  }
}