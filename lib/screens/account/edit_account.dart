import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  var marketData;
  final urlSingUp = "${Config.API_URL}/Customer/update";
  final snackBarEdit = SnackBar(content: Text("กำลังบันทึกการแก้ไข..."));
  final snackBarEditSuccess = SnackBar(content: Text("แก้ไขสำเร็จ"));
  final snackBarEditFall = SnackBar(content: Text("แก้ไขผิดพลาด"));

  String? name_store;
  String? name;
  String? surname;
  String? email;
  String? phone_number;
  String? description_store;
  String? image;
  File? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name_store = marketData.name_store;
    name = marketData.name;
    surname = marketData.surname;
    email = marketData.email;
    phone_number = marketData.phone_number;
    description_store = marketData.description_store;
    image = marketData.image;
  }

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
                  child: image == null
                      ? Icon(Icons.image,size: 30,)
                      : Image.memory(
                          base64Decode(image!),
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
                      _showAlertSelectImage(context);
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
              child: Column(
                children: [
                  TextField(
                    maxLength: 32,
                    decoration: InputDecoration(
                        hintText: " ชื่อร้าน : ${marketData.name_store}"),
                    onChanged: (text) {
                      setState(() {
                        name_store = text;
                      });
                    },
                  ),
                  TextField(
                    maxLength: 32,
                    decoration: InputDecoration(
                        hintText: " ชื่อเจ้าของร้าน : ${marketData.name}"),
                    onChanged: (text) {
                      setState(() {
                        name = text;
                      });
                    },
                  ),
                  TextField(
                    maxLength: 32,
                    decoration: InputDecoration(
                        hintText: " นามสกุล : ${marketData.surname}"),
                    onChanged: (text) {
                      setState(() {
                        surname = text;
                      });
                    },
                  ),
                  TextField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText:
                            " เบอร์โทรติดต่อ : ${marketData.phone_number}"),
                    onChanged: (text) {
                      setState(() {
                        phone_number = text;
                      });
                    },
                  ),
                  TextField(
                    maxLength: 100,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText:
                            " รายละเอียดที่อยู่: ${marketData.description_store}"),
                    onChanged: (text) {
                      setState(() {
                        description_store = text;
                      });
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print("save edit");
                  editMarketData();
                },
                child: Text('บันทึก'),
                style: ElevatedButton.styleFrom(primary: Colors.orange[600])),
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

  void editMarketData() {
    print("market ID : ${marketData.id.toString()}");
    print("ชื่อร้าน : ${name_store.toString()}");
    print("ชื่อ : ${name.toString()}");
    print("นามสกุล : ${surname.toString()}");
    print("อีเมล : ${email.toString()}");
    print("เบอร์โทร : ${phone_number.toString()}");
    print("ที่อยู่ : ${description_store.toString()}");
    saveToDB();
  }

  void saveToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarEdit);
    Map params = Map();
    params['id'] = marketData.id.toString();
    params['image'] = image.toString();
    params['email'] = email.toString();
    params['password'] = marketData.password.toString();
    params['name_store'] = name_store.toString();
    params['name'] = name.toString();
    params['surname'] = surname.toString();
    params['phone_number'] = phone_number.toString();
    params['description_store'] = description_store.toString();

    http.post(urlSingUp, body: params).then((res) {
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
