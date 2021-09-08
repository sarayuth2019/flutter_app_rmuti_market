import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyAdminTab extends StatefulWidget {
  NotifyAdminTab(this.token, this.marketId);

  final token;
  final marketId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotifyAdminTab(token, marketId);
  }
}

class _NotifyAdminTab extends State {
  _NotifyAdminTab(this.token, this.marketId);

  final token;
  final marketId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text("admin notify"),
      ),
    );
  }
}
