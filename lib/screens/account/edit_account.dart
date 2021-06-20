import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditAccount extends StatefulWidget {
  EditAccount(this.marketData);

  final marketData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditAccount(marketData);
  }
}

class _EditAccount extends State {
  _EditAccount(this.marketData);

  final marketData;

  String? name;
  String? surname;
  String? email;
  String? phone_number;
  String? name_store;
  String? description_store;
  String? image;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Market ID : ${marketData.id}"),
        backgroundColor: Colors.orange[600],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  child: Image.memory(
                    base64Decode(marketData.image),
                    fit: BoxFit.fill,
                  ),
                  color: Colors.blueGrey,
                  height: 270,
                  width: double.infinity,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      print("edit image");
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.orange[600],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          hintText: "ชื่อร้าน : ${marketData.name_store}"),
                      onChanged: (text) {
                        setState(() {
                          name_store = text;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "ชื่อเจ้าของร้าน : ${marketData.name}"),
                      onChanged: (text) {
                        setState(() {
                          name = text;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "นามสกุล : ${marketData.surname}"),
                      onChanged: (text) {
                        setState(() {
                          surname = text;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "อีเมล : ${marketData.email}"),
                      onChanged: (text) {
                        setState(() {
                          email = text;
                        });
                      },
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText:
                              "เบอร์โทรติดต่อ : ${marketData.phone_number}"),
                      onChanged: (text) {
                        setState(() {
                          phone_number = text;
                        });
                      },
                    ),
                    TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText:
                              "รายละเอียดที่อยู่: ${marketData.description_store}"),
                      onChanged: (text) {
                        setState(() {
                          description_store = text;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print("save edit");
              },
              child: Text('บันทึก'),
              style: ElevatedButton.styleFrom(primary: Colors.orange[600])),
          ],
        ),
      ),
    );
  }
}
