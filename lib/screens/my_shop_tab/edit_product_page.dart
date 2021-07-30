import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProductPage extends StatefulWidget {
  EditProductPage(this.itemData, this.token);

  var itemData;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditProductPage(itemData, token);
  }
}

class _EditProductPage extends State {
  _EditProductPage(this.itemData, this.token);

  final itemData;
  final token;

  int? marketID;
  String? nameItem;
  int group = 1;
  int? price;
  int? priceSell;
  int? count;
  int? countRequest;
  File? imageFile;
  String? imageData;
  String? dealBegin;
  String? dealFinal;
  String? dateBegin;
  String? dateFinal;
  final snackBarOnSave =
      SnackBar(content: Text("กำลังแก้ไขสินค้า กรุณารอซักครู่..."));
  final snackBarOnSaveSuccess = SnackBar(content: Text("แก้ไขสินค้า สำเร็จ !"));
  final snackBarSaveFail = SnackBar(content: Text("แก้ไขสินค้า ล้มเหลว !"));
  final urlSellProducts = "${Config.API_URL}/Item/update";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marketID = itemData.marketID;
    nameItem = itemData.nameItem;
    price = itemData.price;
    priceSell = itemData.priceSell;
    count = itemData.count;
    countRequest = itemData.countRequest;
    dealBegin = itemData.dealBegin;
    dealFinal = itemData.dealFinal;
    dateBegin = itemData.dateBegin;
    dateFinal = itemData.dateFinal;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Edit Product ID",
            style: TextStyle(color: Colors.teal),
          ),
        ),
        body: SingleChildScrollView(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อสินค้า'),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: TextField(
                              decoration: InputDecoration(border: InputBorder.none),
                              controller: TextEditingController(text: nameItem),
                              onChanged: (text) {
                                nameItem = text;
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ราคาลด'),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            decoration: InputDecoration(border: InputBorder.none),
                            keyboardType: TextInputType.number,
                            controller:
                                TextEditingController(text: priceSell.toString()),
                            onChanged: (num) {
                              priceSell = int.parse(num);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ราคาปกติ'),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            decoration: InputDecoration(border: InputBorder.none),
                            keyboardType: TextInputType.number,
                            controller:
                                TextEditingController(text: price.toString()),
                            onChanged: (num) {
                              price = int.parse(num);
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
                      Text('จำนวนคนที่ต้องการ'),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            decoration: InputDecoration(border: InputBorder.none),
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: countRequest.toString()),
                            onChanged: (num) {
                              countRequest = int.parse(num);
                            },
                          ),
                        ),
                      ),
                    ],
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.teal),
                      child: Text(
                        "แก้ไขสินค้า",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: updateItemData),
                )
              ],
            ),
          ),
        ));
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

  void updateItemData() {
    print(itemData.nameItem);
    print(price.toString());
    print(itemData.dateBegin);
    saveToDB();
  }

  void saveToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnSave);
    Map params = Map();
    params['itemId'] = itemData.itemID.toString();
    params['marketId'] = itemData.marketID.toString();
    params['nameItems'] = nameItem.toString();
    params['groupItems'] = group.toString();
    params['price'] = price.toString();
    params['priceSell'] = priceSell.toString();
    params['count'] = count.toString();
    params['countRequest'] = countRequest.toString();
    params['dateBegin'] = dateBegin.toString();
    params['dateFinal'] = dateFinal.toString();
    params['dealBegin'] = dealBegin.toString();
    params['dealFinal'] = dealFinal.toString();
    params['imageItems'] = imageData.toString();

    http.post(Uri.parse(urlSellProducts), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      Navigator.of(context).pop();

      Map _resData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      print(_resData);
      var _resStatus = _resData['status'];
      setState(() {
        if (_resStatus == 1) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarOnSaveSuccess);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarSaveFail);
        }
      });
    });
  }
}
