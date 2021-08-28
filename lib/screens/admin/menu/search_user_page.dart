import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUserPage extends StatefulWidget{
  SearchUserPage(this.token);
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchUserPage(token);
  }
}
class _SearchUserPage extends State{
  _SearchUserPage(this.token);
  final token;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}

