import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  AccountPage(this.accountID);
  final accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountPage(accountID);
  }
}

class _AccountPage extends State {
  _AccountPage(this.accountID);
  final accountID;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[600],
        child: Icon(Icons.edit),
        onPressed: () {},
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: Icon(
                Icons.photo_camera_back,
                color: Colors.white,
                size: 100,
              ),
            ),
            color: Colors.blueGrey,
            height: 250,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Market ID : ${accountID.toString()}"),
          )
        ],
      ),
    );
  }
}
