import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SellProducts extends StatefulWidget {
  SellProducts(this.token, this.marketID);

  final token;
  final marketID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SellProducts(this.token, this.marketID);
  }
}

class _SellProducts extends State {
  _SellProducts(this.token, this.marketID);

  final token;
  final marketID;

  final _formKey = GlobalKey<FormState>();

  final urlSellProducts = "${Config.API_URL}/Item/save";
  final urlSaveImage = "${Config.API_URL}/images/save";
  final snackBarOnSave =
      SnackBar(content: Text("กำลังขายลงขาย กรุณารอซักครู่..."));
  final snackBarOnSaveSuccess = SnackBar(content: Text("ลงขายสินค้า สำเร็จ !"));
  final snackBarSaveFail = SnackBar(content: Text("ลงขายสินค้า ล้มเหลว !"));
  final snackBarNoImage =
      SnackBar(content: Text("กรุณาใส่รูปภาพสินค้าอย่างน้อย 1 รูป"));
  final snackBarNoLocation = SnackBar(content: Text("กรุณาเลือกสถานที่"));
  final snackBarNoGroupItem = SnackBar(content: Text("กรุณาเลือกประเภทสินค้า"));
  final snackBarNoDateTime = SnackBar(content: Text("กรอกวันที่ให้ครบ"));
  bool checkText = false;
  String textPromotion = "เพิ่มโปรโมชันสินค้า";

  BoxDecoration _boxDecorationGrey = BoxDecoration(
      border: Border.all(color: Colors.grey[350]!),
      borderRadius: BorderRadius.circular(5));

  String? nameMenu;
  int group = 1;
  int? price;
  int? priceSell;
  int count = 0;
  int? countRequest;
  File? imageFile;
  List<File> listImageFile = [];
  String? imageData1;
  String? dealBegin;
  String? dealFinal;
  String? dateBegin;
  String? dateFinal;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Sell Product",
          style: TextStyle(color: Colors.teal),
        ),
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
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: _boxDecorationGrey,
                  child: listImageFile.length == 0
                      ? Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                              Text("รูปภาพ"),
                            ],
                          ),
                        )
                      : Container(
                          child: CarouselSlider(
                            options: CarouselOptions(
                                initialPage: 0,
                                enlargeCenterPage: true,
                                autoPlay: false),
                            items: listImageFile
                                .map((e) => Stack(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: double.infinity,
                                          child: Image.file(
                                            e,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  listImageFile.remove(e);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              )),
                                        )
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _showAlertSelectImage(context);
                      },
                      child: Container(
                        decoration: _boxDecorationGrey,
                        height: 50,
                        width: 120,
                        child: Center(
                          child: Column(
                            children: [Icon(Icons.add), Text("เพิ่มรูปภาพ")],
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration:_boxDecorationGrey,
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
                    decoration: _boxDecorationGrey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ": ราคาลด", border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        validator: _checkPrice,
                        onSaved: (String? num) {
                          priceSell = int.parse(num!);
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: _boxDecorationGrey,
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
                    decoration: _boxDecorationGrey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: ": จำนวนคนที่ต้องการ",
                            border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        validator: _checkNumUser,
                        onSaved: (String? num) {
                          countRequest = int.parse(num!);
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                              Text("${dealBegin ?? 'เลือกวันที่'}"),
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
                              Text("${dealFinal ?? 'เลือกวันที่'}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                              Text('${dateBegin ?? 'เลือกวันที่'}'),
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
                              Text("${dateFinal ?? 'เลือกวันที่'}"),
                            ],
                          ),
                        ],
                      ),
                    ],
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
        dealBegin = "${date!.month}/${date.day}/${date.year}";
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
        dealFinal = "${date!.month}/${date.day}/${date.year}";
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
        dateBegin = "${date!.month}/${date.day}/${date.year}";
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
        dateFinal = "${date!.month}/${date.day}/${date.year}";
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
                          child: Text('Gallery'),
                          onTap: () {
                            _onGallery();
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('Camera'),
                          onTap: () {
                            _onCamera();
                          })),
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
        listImageFile.insert(0, imageFile!);
      });
      Navigator.of(context).pop();
      return listImageFile;
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
        listImageFile.insert(0, imageFile!);
      });
      Navigator.of(context).pop();
      return listImageFile;
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
    if (listImageFile.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoImage);
    } else if (dealBegin == null ||
        dealFinal == null ||
        dateBegin == null ||
        dateFinal == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoDateTime);
    } else if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(snackBarOnSave);
      print("account Id ${marketID.toString()}");
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
    params['marketId'] = marketID.toString();
    params['nameItems'] = nameMenu.toString();
    params['groupItems'] = group.toString();
    params['price'] = price.toString();
    params['priceSell'] = priceSell.toString();
    params['count'] = count.toString();
    params['countRequest'] = countRequest.toString();
    params['dateBegin'] = dateBegin.toString();
    params['dateFinal'] = dateFinal.toString();
    params['dealBegin'] = dealBegin.toString();
    params['dealFinal'] = dealFinal.toString();
    //params['imageItems'] = imageFile.toString();
    http.post(Uri.parse(urlSellProducts), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      Navigator.of(context).pop();

      Map _res = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      print(_res);
      var _resStatus = _res['status'];
      var _resData = _res['data'];
      var _itemId = _resData['itemId'];
      setState(() {
        if (_resStatus == 0) {
          saveImage(_itemId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarSaveFail);
        }
      });
    });
  }

  void saveImage(_itemId) async {
    print("ItemID : ${_itemId.toString()}");

    listImageFile.forEach((element) async {
      print("save image Item ID : ${_itemId.toString()}");
      print("Update image File : ${element}");

      var request = http.MultipartRequest('POST', Uri.parse(urlSaveImage));

      var _multipart =
          await http.MultipartFile.fromPath('picture', element.path);
      request.files.add(_multipart);

      request.headers.addAll(
          {HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'});
      request.fields['itemId'] = _itemId.toString();
      request.fields['marketId'] = marketID.toString();

      await http.Response.fromStream(await request.send()).then((res) {
        print(res.body);
      });
    });
  }
}
