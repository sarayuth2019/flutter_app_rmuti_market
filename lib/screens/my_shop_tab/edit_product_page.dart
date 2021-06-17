import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProductPage extends StatefulWidget {
  EditProductPage(
      this.id,
      this.name,
      this.group,
      this.description,
      this.price,
      this.location,
      this.user_id,
      this.discount,
      this.count_promotion,
      this.status_promotion,
      this.date,
      this.image);

  final int id;
  final String name;
  final int group;
  final String description;
  final int price;
  final String location;
  final int user_id;
  final int discount;
  final int count_promotion;
  final int status_promotion;
  final String date;
  final String image;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditProductPage(id, name, group, description, price, location,
        user_id, discount, count_promotion, status_promotion, date, image);
  }
}

class _EditProductPage extends State {
  _EditProductPage(
      this.id,
      this.name,
      this.group,
      this.description,
      this.price,
      this.location,
      this.user_id,
      this.discount,
      this.count_promotion,
      this.status_promotion,
      this.date,
      this.image);

  final int id;
  String? name;
  final int? group;
  String? description;
  int? price;
  final String? location;
  final int? user_id;
  int? discount;
  int? count_promotion;
  int? status_promotion;
  final String? date;
  String? image;
  File? imageFile;

  final snackBarOnSave =
      SnackBar(content: Text("กำลังแก้ไขสินค้า กรุณารอซักครู่..."));
  final snackBarOnSaveSuccess = SnackBar(content: Text("แก้ไขสินค้า สำเร็จ !"));
  final snackBarSaveFail = SnackBar(content: Text("แก้ไขสินค้า ล้มเหลว !"));
  final urlSellProducts = "${Config.API_URL}/Item/save";
  String textPromotion = "แก้ไขโปรโมชันสินค้า";

  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _countPromotion = TextEditingController();
  TextEditingController _discountPromotion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text("Edit Product ID ${id.toString()}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  _showAlertSelectImage(context);
                },
                child: Image.memory(
                  base64Decode(image!),
                  fit: BoxFit.fill,
                  height: 340,
                  width: double.infinity,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                          hintText: "ชื่อสินค้า : ${name.toString()}"),
                      onChanged: (String text) {
                        name = text;
                      },
                    ),
                    TextField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "ราคา : ${price.toString()} บาท"),
                      onChanged: (String num) {
                        price = int.parse(num);
                      },
                    ),
                    TextField(
                      controller: _description,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: "คำอธิบาย : ${description.toString()}"),
                      onChanged: (String text) {
                        description = text;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "โปรโมชันสินค้าปัจจุบัน",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "ซื้อสินค้าครบ ${count_promotion.toString()} ชิ้น ได้ส่วนลดของสินค้า ${discount.toString()} %",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: RaisedButton(
                  color: Colors.grey,
                  child: Text(
                    textPromotion,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    addPromotion(context);
                  }),
            ),
            Center(
              child: RaisedButton(
                  color: Colors.orange[600],
                  child: Text(
                    "บันทึกการแก้ไข",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: testApp),
            )
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
      image = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return image;
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
      image = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return image;
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
                  controller: _countPromotion,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "ซื้อครบ ${count_promotion.toString()} ชิ้น"),
                ),
                TextField(
                  controller: _discountPromotion,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "รับส่วนลด ${discount.toString()} %"),
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
    count_promotion = int.parse(_countPromotion.text);
    discount = int.parse(_discountPromotion.text);
    status_promotion = 1;
    setState(() {
      textPromotion =
          "ซื้อครบ ${count_promotion.toString()} ชิ้น ได้ส่วนลด ${discount.toString()}%";
      print(
          "เพิ่มโปรโมชัน statusPro ${status_promotion.toString()} ซื้อ ${count_promotion.toString()} ลด ${discount.toString()} %");
      Navigator.of(context).pop();
    });
  }

  void cancelPromotion() {
    count_promotion = 0;
    discount = 0;
    status_promotion = 0;
    setState(() {
      _countPromotion.clear();
      _discountPromotion.clear();
      textPromotion = "แก้ไขโปรโมชันสินค้า";
      print(
          "ยกเลิกโปรโมชัน statusPro ${status_promotion.toString()} ซื้อ ${count_promotion.toString()} ลด ${discount.toString()} %");
      Navigator.of(context).pop();
    });
  }

  void testApp() {
    print(name);
    print(price.toString());
    print(description);
    print(
        'โปรโมชัน statusPro ${status_promotion.toString()} ซื้อ ${count_promotion.toString()} ลด ${discount.toString()} %');
    saveToDB();
  }

  void saveToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnSave);
    Map params = Map();
    params['id'] = id.toString();
    params['user'] = user_id.toString();
    params['name'] = name.toString();
    params['price'] = price.toString();
    params['description'] = description.toString();
    params['location'] = location.toString();
    params['group'] = group.toString();
    params['image'] = image.toString();
    params['count_promotion'] = count_promotion.toString();
    params['discount'] = discount.toString();
    params['promotion'] = status_promotion.toString();

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
