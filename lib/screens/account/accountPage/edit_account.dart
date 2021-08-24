import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditAccount extends StatefulWidget {
  EditAccount(this.marketData, this.token);

  final marketData;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditAccount(marketData, token);
  }
}

class _EditAccount extends State {
  _EditAccount(this.marketData, this.token);

  var marketData;
  final token;

  final urlUpdate = "${Config.API_URL}/Market/update";
  final snackBarEdit = SnackBar(content: Text("กำลังบันทึกการแก้ไข..."));
  final snackBarEditSuccess = SnackBar(content: Text("แก้ไขสำเร็จ"));
  final snackBarEditFall = SnackBar(content: Text("แก้ไขผิดพลาด"));


  String? nameMarket;
  String? name;
  String? surname;
  String? email;
  String? phoneNumber;
  String? descriptionMarket;
  String? imageMarket;
  File? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameMarket = marketData.nameMarket;
    name = marketData.name;
    surname = marketData.surname;
    email = marketData.email;
    phoneNumber = marketData.phoneNumber;
    descriptionMarket = marketData.descriptionMarket;
    imageMarket = marketData.imageMarket;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          "แก้ไขข้อมูลผู้ใช้",
          style: TextStyle(color: Colors.teal),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: imageMarket == null
                  ? Icon(
                      Icons.image,
                      size: 30,
                    )
                  : GestureDetector(
                      onTap: () {
                        _showAlertSelectImage(context);
                      },
                      child: Image.memory(
                        base64Decode(imageMarket!),
                        fit: BoxFit.fill,
                      ),
                    ),
              color: Colors.blueGrey,
              height: 270,
              width: double.infinity,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อร้านค้า'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: TextEditingController(text: nameMarket),
                            onChanged: (text) {
                              nameMarket = text;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อเจ้าของร้าน'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: TextEditingController(text: name),
                            onChanged: (text) {
                              name = text;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('นามสกุล'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: TextEditingController(text: surname),
                            onChanged: (text) {
                              surname = text;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('เบอร์โทร'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: TextEditingController(
                                text: phoneNumber.toString()),
                            onChanged: (text) {
                              phoneNumber = text;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('รายละเอียดที่ตั้งร้าน'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            maxLines: null,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller:
                                TextEditingController(text: descriptionMarket),
                            onChanged: (text) {
                              descriptionMarket = text;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  print("save edit");
                  editMarketData();
                },
                child: Text('บันทึก'),
                style: ElevatedButton.styleFrom(primary: Colors.teal)),
          ],
        ),
      ),
    );
  }

  void _showAlertSelectImage(BuildContext context) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Choice'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('Gallery'), onTap: _onGallery)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('Camera'), onTap: _onCamera)),
                ],
              ),
            ),
          );
        });
  }

  _onGallery() async {
    print('Select Gallery');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      imageMarket = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return imageMarket;
    } else {
      return null;
    }
  }

  _onCamera() async {
    print('Select Camera');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 1920, maxWidth: 1080);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      imageMarket = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return imageMarket;
    } else {
      return null;
    }
  }

  void editMarketData() {
    print("market ID : ${marketData.marketID.toString()}");
    print("ชื่อร้าน : ${nameMarket.toString()}");
    print("ชื่อ : ${name.toString()}");
    print("นามสกุล : ${surname.toString()}");
    print("อีเมล : ${email.toString()}");
    print("เบอร์โทร : ${phoneNumber.toString()}");
    print("ที่อยู่ : ${descriptionMarket.toString()}");
    saveToDB();
  }

  void saveToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarEdit);
    String _statusMarket = "user";
    Map params = Map();
    params['marketId'] = marketData.marketID.toString();
    params['imageMarket'] = imageMarket.toString();
    params['email'] = email.toString();
    params['password'] = marketData.password.toString();
    params['nameMarket'] = nameMarket.toString();
    params['name'] = name.toString();
    params['surname'] = surname.toString();
    params['phoneNumber'] = phoneNumber.toString();
    params['statusMarket'] = _statusMarket;
    params['descriptionMarket'] = descriptionMarket.toString();

    http.post(Uri.parse(urlUpdate), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      Navigator.of(context).pop();
      print(res.body);
      Map resBody = jsonDecode(res.body) as Map;
      var _resStatus = resBody['status'];
      print("Sing Up Status : ${_resStatus}");

      setState(() {
        if (_resStatus == 1) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarEditSuccess);
        } else if (_resStatus == 0) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarEditFall);
          //_snackBarKey.currentState.showSnackBar(singUpFail);
        }
      });
    });
  }
}
