import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProductPage extends StatefulWidget {
  EditProductPage(this.productData
     );
  var productData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditProductPage(productData);
  }
}

class _EditProductPage extends State {
  _EditProductPage(
      this.productData
     );
  final productData;
  int? accountID;
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

  final snackBarOnSave =
      SnackBar(content: Text("กำลังแก้ไขสินค้า กรุณารอซักครู่..."));
  final snackBarOnSaveSuccess = SnackBar(content: Text("แก้ไขสินค้า สำเร็จ !"));
  final snackBarSaveFail = SnackBar(content: Text("แก้ไขสินค้า ล้มเหลว !"));
  final urlSellProducts = "${Config.API_URL}/Item/save";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Edit Product ID",style: TextStyle(color: Colors.teal),),
      ),
      body: Text("${productData.name}")
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


  void testApp() {
    print(productData.name);
    print(price.toString());
    print(productData.date_begin);
    //saveToDB();
  }

  /*void saveToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnSave);
    Map params = Map();
    params['userId'] = accountID.toString();
    params['nameItems'] = nameMenu.toString();
    params['groupItems'] = group.toString();
    params['price'] = price.toString();
    params['priceSell'] = price_sell.toString();
    params['count'] = count.toString();
    params['countRequest'] = count_request.toString();
    params['dateBegin'] = date_begin.toString();
    params['dateFinal'] = date_final.toString();
    params['dealBegin'] = deal_begin.toString();
    params['dealFinal'] = deal_final.toString();
    params['imageItems'] = imageData.toString();

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
  }*/
}
