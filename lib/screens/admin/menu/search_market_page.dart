import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchMarketPage extends StatefulWidget {
  SearchMarketPage(this.token);

  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchMarketPage(token);
  }
}

class _SearchMarketPage extends State {
  _SearchMarketPage(this.token);

  final token;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}