import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class SellProducts extends StatefulWidget {
  SellProducts(this.accountID);

  final accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SellProducts(accountID);
  }
}

class _SellProducts extends State {
  _SellProducts(this.accountID);

  final _formKey = GlobalKey<FormState>();

  final urlSellProducts = "${Config.API_URL}/Item/save";
  final snackBarOnSave =
      SnackBar(content: Text("กำลังขายลงขาย กรุณารอซักครู่..."));
  final snackBarOnSaveSuccess = SnackBar(content: Text("ลงขายสินค้า สำเร็จ !"));
  final snackBarSaveFail = SnackBar(content: Text("ลงขายสินค้า ล้มเหลว !"));
  final snackBarNoImage = SnackBar(content: Text("กรุณาใส่รูปภาพสินค้า"));
  final snackBarNoLocation = SnackBar(content: Text("กรุณาเลือกสถานที่"));
  final snackBarNoGroupItem = SnackBar(content: Text("กรุณาเลือกประเภทสินค้า"));
  bool checkText = false;
  String textPromotion = "เพิ่มโปรโมชันสินค้า";

  final int accountID;
  String? nameMenu;
  int group = 1;
  int? price;
  int? price_sell;
  int count = 0;
  int? count_request;
  File? imageFile;
  String? imageData;
  String? deal_begin;
  String? deal_final;
  String? date_begin;
  String? date_final;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          // ignore: deprecated_member_use
          autovalidate: checkText,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _showAlertSelectImage(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: imageData == null
                        ? Container(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                                Text("เลือกรูปภาพ")
                              ],
                            ),
                          )
                        : Container(
                            child: Image.memory(
                              base64Decode(imageData!),
                              fit: BoxFit.fill,
                              height: 150,
                              width: double.infinity,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ": ชื่อสินค้า", border: InputBorder.none),
                        validator: _checkText,
                        onSaved: (String? text) {
                          nameMenu = text;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ": ราคาลด", border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        validator: _checkPrice,
                        onSaved: (String? num) {
                          price_sell = int.parse(num!);
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ": ราคาเต็ม", border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        validator: _checkPrice,
                        onSaved: (String? num) {
                          price = int.parse(num!);
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ": จำนวนคนที่ต้องการ",
                            border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        validator: _checkNumUser,
                        onSaved: (String? num) {
                          count_request = int.parse(num!);
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        Text(
                          "ระยะเวลาในการลงทะเบียน",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pickDealBegin(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                                Text("วันเริ่ม"),
                                Text("${deal_begin ?? 'เลือกวันที่'}"),
                              ],
                            ),
                            Icon(Icons.arrow_forward),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pickDealFinal(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                                Text("วันสิ้นสุด"),
                                Text("${deal_final ?? 'เลือกวันที่'}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        Text(
                          "ระยะเวลาในการใช้สิทธิ์ลดราคา",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pickDateBegin(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                                Text("วันเริ่ม"),
                                Text('${date_begin ?? 'เลือกวันที่'}'),
                              ],
                            ),
                            Icon(Icons.arrow_forward),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pickDateFinal(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                                Text("วันสิ้นสุด"),
                                Text("${date_final ?? 'เลือกวันที่'}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.teal),
                      child: Text(
                        "ลงขายสินค้า",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: onSaveData),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _pickDealBegin(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        deal_begin = "${date!.month}/${date.day}/${date.year}";
        print(date);
      });
    });
  }

  Future _pickDealFinal(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        deal_final = "${date!.month}/${date.day}/${date.year}";
        print(date);
      });
    });
  }

  Future _pickDateBegin(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        date_begin = "${date!.month}/${date.day}/${date.year}";
        print(date);
      });
    });
  }

  Future _pickDateFinal(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        date_final = "${date!.month}/${date.day}/${date.year}";
        print(date);
      });
    });
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
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return imageData;
    } else {
      return null;
    }
  }

  _onCamera() async {
    print('Select Camera');
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 1920, maxWidth: 1080);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return imageData;
    } else {
      return null;
    }
  }

  String? _checkText(text) {
    if (text.length == 0) {
      return "กรุณาใส่ชื่อสินค้า";
    } else {
      return null;
    }
  }

  String? _checkPrice(text) {
    if (text.length == 0) {
      return "กรุณาใส่ราคาสินค้า";
    } else {
      return null;
    }
  }

  String? _checkNumUser(text) {
    if (text.length == 0) {
      return "กรุณาจำนวนคนที่ต้องการ";
    } else {
      return null;
    }
  }

  void onSaveData() {
    if (imageData == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoImage);
    } else if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(snackBarOnSave);

      print("account Id ${accountID.toString()}");
      print("name product : ${nameMenu.toString()}");
      print("price : ${price.toString()}");

      saveToDB();
    } else {
      setState(() {
        checkText = true;
      });
    }
  }

  void saveToDB() async {
    Map params = Map();
    params['user'] = accountID.toString();
    params['name'] = nameMenu.toString();
    params['group'] = group.toString();
    params['price'] = price.toString();
    params['price_sell'] = price_sell.toString();
    params['count'] = count.toString();
    params['count_request'] = count_request.toString();
    params['date_begin'] = date_begin.toString();
    params['date_final'] = date_final.toString();
    params['deal_begin'] = deal_begin.toString();
    params['deal_final'] = deal_final.toString();
    params['image'] = imageData.toString();

    http.post(Uri.parse(urlSellProducts), body: params).then((res) {
      Map _resData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      print(_resData);
      var _resStatus = _resData['status'];
      setState(() {
        if (_resStatus == 0) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarOnSaveSuccess);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarSaveFail);
        }
      });
    });
  }
}
