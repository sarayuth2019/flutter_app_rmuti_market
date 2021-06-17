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
  int? price;
  String? location;
  String? _groupItem;
  int? groupItem;
  String? description;
  File? imageFile;
  String? imageData;
  int countPromotion = 0;
  int discountPromotion = 0;
  int statusPromotion = 0;

  TextEditingController _countPromotion = TextEditingController();
  TextEditingController _discountPromotion = TextEditingController();

  List listDropdownLocation = [
    "ตึก 5",
    "ตึก 7",
    "ตึก 12",
  ];

  List listDropdownGroupItem = [
    "อาหาร&เครื่องดื่ม",
    "อุปกรณ์การเรียน",
    "เครื่องแต่งกาย"
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text("ลงขายสินค้าทีคุณต้องการ"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          // ignore: deprecated_member_use
          autovalidate: checkText,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "กรุณากรอกข้อมูลสินค้าให้ครบ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _showAlertSelectImage(context);
                      },
                      child: Container(
                        child: imageData == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 250,
                                  width: 310,
                                  color: Colors.grey,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  child: Image.memory(
                                    base64Decode(imageData!),
                                    fit: BoxFit.fill,
                                    height: 250,
                                    width: 310,
                                  ),
                                ),
                              ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DropdownButton(
                    hint: Text("เลือกสถานที่"),
                    isExpanded: true,
                    underline: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                    ),
                    value: location,
                    onChanged: (newValue) {
                      setState(() {
                        location = newValue as String?;
                        print(location);
                      });
                    },
                    items: listDropdownLocation.map((_value) {
                      return DropdownMenuItem(
                          value: _value, child: Text(_value));
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DropdownButton(
                    hint: Text("เลือกประเภทของสินค้า"),
                    isExpanded: true,
                    underline: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                    ),
                    value: _groupItem,
                    onChanged: (newValue) {
                      setState(() {
                        _groupItem = newValue as String?;
                        print(_groupItem);
                        if (_groupItem == "อาหาร&เครื่องดื่ม") {
                          groupItem = 1;
                        } else if (_groupItem == "อุปกรณ์การเรียน") {
                          groupItem = 2;
                        } else if (_groupItem == "เครื่องแต่งกาย") {
                          groupItem = 3;
                        } else {
                          return null;
                        }
                        print("GroupItem : ${groupItem.toString()}");
                      });
                    },
                    items: listDropdownGroupItem.map((_value) {
                      return DropdownMenuItem(
                          value: _value, child: Text(_value));
                    }).toList(),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "ชื่อสินค้า"),
                  validator: _checkText,
                  onSaved: (String? text) {
                    nameMenu = text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "ราคาสินค้า : บาท"),
                  keyboardType: TextInputType.number,
                  validator: _checkPrice,
                  onSaved: (String? num) {
                    price = int.parse(num!);
                  },
                ),
                TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(hintText: "คำอธิบาย"),
                  validator: _checkDescription,
                  onSaved: (String? text) {
                    description = text;
                  },
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                    color: Colors.grey,
                    child: Text(
                      textPromotion,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      addPromotion(context);
                    }),
                // ignore: deprecated_member_use
                RaisedButton(
                    color: Colors.orange[600],
                    child: Text(
                      "ลงขายสินค้า",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: onSaveData)
              ],
            ),
          ),
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
      imageData = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return imageData;
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

  String? _checkDescription(text) {
    if (text.length == 0) {
      return "กรุณาคำอธิบายสินค้า";
    } else {
      return null;
    }
  }

  void addPromotion(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("กรุณาใส่โปรโมชันสินค้า"),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _countPromotion,
                  decoration: InputDecoration(
                      hintText: "จำนวนต่ำสุดของการได้รับโปรโมชัน"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _discountPromotion,
                  decoration: InputDecoration(hintText: "ส่วนลดของสินค้า %"),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange[600])),
                    child: Text("บันทึกโปรโมชัน"),
                    onPressed: savePromotion),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  child: Text("ยกเลิกโปรโมชัน"),
                  onPressed: cancelPromotion,
                )
              ],
            )),
          );
        });
  }

  void savePromotion() {
    countPromotion = int.parse(_countPromotion.text);
    discountPromotion = int.parse(_discountPromotion.text);
    statusPromotion = 1;
    setState(() {
      textPromotion =
          "ซื้อ ${countPromotion.toString()} ได้ส่วนลด ${discountPromotion.toString()}%";
      print(
          "เพิ่มโปรโมชัน statusPro ${statusPromotion.toString()} ซื้อ ${countPromotion.toString()} ลด ${discountPromotion.toString()} %");
      Navigator.of(context).pop();
    });
  }

  void cancelPromotion() {
    countPromotion = 0;
    discountPromotion = 0;
    statusPromotion = 0;
    setState(() {
      _countPromotion.clear();
      _discountPromotion.clear();
      textPromotion = "เพิ่มโปรโมชันสินค้า";
      print(
          "ยกเลิกโปรโมชัน statusPro ${statusPromotion.toString()} ซื้อ ${countPromotion.toString()} ลด ${discountPromotion.toString()} %");
      Navigator.of(context).pop();
    });
  }

  void onSaveData() {
    if (imageData == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoImage);
    } else if (location == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoLocation);
    } else if (groupItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoGroupItem);
    } else if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(snackBarOnSave);

      print("account Id ${accountID.toString()}");
      print("name product : ${nameMenu.toString()}");
      print("price : ${price.toString()}");
      print("group item : ${groupItem.toString()}");
      print(
          "โปรโมชัน statusPro ${statusPromotion.toString()} ซื้อ ${countPromotion.toString()} ลด ${discountPromotion.toString()} %");

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
    params['price'] = price.toString();
    params['description'] = description.toString();
    params['location'] = location.toString();
    params['group'] = groupItem.toString();
    params['image'] = imageData.toString();
    params['count_promotion'] = countPromotion.toString();
    params['discount'] = discountPromotion.toString();
    params['promotion'] = statusPromotion.toString();

    http.post(urlSellProducts, body: params).then((res) {
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
