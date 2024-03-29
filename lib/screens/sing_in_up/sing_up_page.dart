import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_bank_market.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SingUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SingUp();
  }
}

class _SingUp extends State {
  final urlSingUp = "${Config.API_URL}/Register/market";
  final _formKey = GlobalKey<FormState>();
  final _snackBarKey = GlobalKey<ScaffoldState>();
  final singUpSnackBar =
      SnackBar(content: Text("กำลังสมัคสมาชิก กรุณารอซักครู่..."));
  final singUpFail = SnackBar(content: Text("Email นี้มีผู้ใช้แล้ว"));
  final snackBarNoImage = SnackBar(content: Text("กรุณาเพิ่มรูปภาพร้าน"));
  bool _checkText = false;
  String? email;
  String? password;
  TextEditingController confirmPass = TextEditingController();
  String? nameMarket;
  String? name;
  String? surname;
  String? number;
  String? marketAddress;
  File? imageFile;
  String? imageData;

  List<String> _listBankName = [
    'พร้อมเพย์',
    'ธนาคารไทยพาณิชย์ SCB',
    'ธนาคารกรุงเทพ BBL',
    'ธนาคารกสิกรไทย KBANK',
    'ธนาคารกรุงไทย KTB',
    'ธนาคารกรุงศรีอยุธยา BAY',
    'ธนาคารทหารไทยธนชาต TTB',
    'ธนาคารออมสิน GSB',
    'ธนาคารอิสลามแห่งประเทศไทย ISBT'
  ];

  var _bankName;
  var _bankNumber;
  var _bankAccountName;
  List<SaveBankMarket> listBankMarket = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _snackBarKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("สมัครสมาชิก"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "กรุณากรอกข้อมูลให้ครบ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                                height: 200,
                                width: 270,
                                color: Colors.grey,
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                child: Image.memory(
                                  base64Decode(imageData!),
                                  fit: BoxFit.fill,
                                  height: 200,
                                  width: 270,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                Text(
                  "รูปถ่ายร้าน",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Email"),
                  maxLength: 32,
                  validator: validateEmail,
                  onSaved: (String? _text) {
                    email = _text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Password"),
                  maxLength: 12,
                  obscureText: true,
                  validator: validatePassword,
                  controller: confirmPass,
                  onSaved: (String? _text) {
                    password = _text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Confirm Password"),
                  maxLength: 12,
                  obscureText: true,
                  validator: validateConfirmPassword,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "ชื่อร้าน"),
                  maxLength: 32,
                  validator: validateNameMarket,
                  onSaved: (String? _text) {
                    nameMarket = _text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "ชื่อเจ้าของร้าน"),
                  maxLength: 32,
                  validator: validateName,
                  onSaved: (String? _text) {
                    name = _text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "นามสกุล"),
                  maxLength: 32,
                  validator: validateSurName,
                  onSaved: (String? _text) {
                    surname = _text;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(hintText: "เบอร์โทรติดต่อ"),
                  validator: validateNumber,
                  onSaved: (String? _num) {
                    number = _num;
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: "รายละเอียดที่ตั้งของร้าน"),
                  maxLength: 100,
                  maxLines: null,
                  validator: validateMarketAddress,
                  onSaved: (String? _text) {
                    marketAddress = _text;
                  },
                ),
                ///////////// เพิ่มข้อมูล ธนาคาร ////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ข้อมูลธนาคารของทางร้าน',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Container(
                  child: listBankMarket.length == 0
                      ? Container()
                      : Container(
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: listBankMarket.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: boxDecorationGrey,
                                    child: ListTile(
                                      title: Text(
                                          '${listBankMarket[index].bankName}'),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'ชื่อบัญชี : ${listBankMarket[index].bankAccountName}'),
                                          Text(
                                              'เลขบัญชี : ${listBankMarket[index].bankNumber}'),
                                        ],
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              listBankMarket.removeAt(index);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.highlight_remove,
                                            color: Colors.red,
                                          )),
                                    ),
                                  ),
                                );
                              }),
                        ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton(
                      value: _bankName,
                      iconEnabledColor: Colors.black,
                      isExpanded: true,
                      underline: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54)),
                      ),
                      hint: Text('เลือกธนาคาร'),
                      items: _listBankName
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _bankName = value as String?;
                          print(_bankName);
                        });
                      },
                    ),
                    _bankName == null
                        ? Container()
                        : Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: TextField(
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: _bankName == "พร้อมเพย์"
                                        ? 'เบอร์ พร้อมเพย์ (ไม่ต้องเว้นวรรค)'
                                        : 'เลขบัญชี (ไม่ต้องเว้นวรรค)',
                                    border: InputBorder.none),
                                onChanged: (text) {
                                  _bankNumber = text;
                                },
                              ),
                            ),
                          ),
                    _bankName == null
                        ? Container()
                        : Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: 'ชื่อบัญชี',
                                    border: InputBorder.none),
                                onChanged: (text) {
                                  _bankAccountName = text;
                                },
                              ),
                            ),
                          ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    onPressed: () {
                      if (_bankName == null ||
                          _bankNumber == null ||
                          _bankAccountName == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('กรุณากรอกข้อมูลธนาคารให้ครบ')));
                      } else {
                        setState(() {
                          addListBank(_bankName, _bankNumber, _bankAccountName)
                              .then((value) => listBankMarket.addAll(value));
                        });
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        Text('เพิ่ม'),
                      ],
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: onSingUp,
                  child: Text(
                    "สมัครสมาชิก",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<SaveBankMarket>> addListBank(
      bankName, bankNumber, bankAccountName) async {
    List<SaveBankMarket> listSaveBank = [];
    listSaveBank.add(SaveBankMarket(bankName, bankNumber, bankAccountName));
    return listSaveBank;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value!.length == 0) {
      return "กรุณากรอกอีเมล";
    } else if (!regExp.hasMatch(value)) {
      return "รูปแบบอีเมลไม่ถูกต้อง";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอก Password";
    } else if (text.length < 6) {
      return "กรุณากรอก Password 6-12";
    } else if (text.length > 12) {
      return "กรุณากรอก Password 6-12 ตัว";
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอก Confirm Password";
    } else if (text != confirmPass.text) {
      return "กรุณากรอก Password ให้ตรงกัน";
    } else {
      return null;
    }
  }

  String? validateNameMarket(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอกชื่อร้าน";
    } else {
      return null;
    }
  }

  String? validateName(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอกชื่อเจ้าของร้าน";
    } else {
      return null;
    }
  }

  String? validateSurName(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอกนามสกุล";
    } else {
      return null;
    }
  }

  String? validateNumber(String? text) {
    String pattern = r'^[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(text!)) {
      return "กรุณากรอกเบอร์ติดต่อให้ถูกต้อง";
    } else {
      return null;
    }
  }

  String? validateMarketAddress(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอกรายละเอียดที่ตั้งของร้าน";
    } else {
      return null;
    }
  }

  void _showAlertSelectImage(context) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (context) {
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
    var _imageGallery = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 1000, imageQuality: 100);
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
    var _imageCamera = await ImagePicker().pickImage(
        source: ImageSource.camera, maxWidth: 1000, imageQuality: 100);
    if (_imageCamera != null) {
      setState(() {
        imageFile = File(_imageCamera.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return imageData;
    } else {
      return null;
    }
  }

  void onSingUp() {
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoImage);
    } else if (listBankMarket.isEmpty || listBankMarket.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณาเพิ่มธนาคารของร้านค้า (สำคัญ!)')));
    } else if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(singUpSnackBar);
      //_snackBarKey.currentState.showSnackBar(singUpSnackBar);
      _formKey.currentState!.save();
      print(email);
      print(password);
      print(nameMarket);
      print(name);
      print(number);
      print(marketAddress);
      _saveToDB();
    } else {
      setState(() {
        _checkText = true;
      });
    }
  }

  void _saveToDB() async {
    var request = http.MultipartRequest('POST', Uri.parse(urlSingUp));
    //request.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'});
    var _multipart =
        await http.MultipartFile.fromPath('marketImage', imageFile!.path);
    request.files.add(_multipart);

    request.fields['email'] = email.toString();
    request.fields['password'] = password.toString();
    request.fields['nameMarket'] = nameMarket.toString();
    request.fields['name'] = name.toString();
    request.fields['surname'] = surname.toString();
    request.fields['phoneNumber'] = number.toString();
    request.fields['descriptionMarket'] = marketAddress.toString();

    await http.Response.fromStream(await request.send()).then((res) {
      print(res.body);

      Map resBody = jsonDecode(res.body) as Map;
      var _resStatus = resBody['status'];
      print("Sing Up Status : ${_resStatus.toString()}");
      setState(() {
        if (_resStatus == 1) {
          var dataSingUp = resBody['data'];
          var _marketId = dataSingUp['marketId'];
          print('SaveBankMarket marketId : ${_marketId.toString()}');
          //////////////บันทึกข้อมูลธนาคาร//////////////////////////
          for (int i = 0; i < listBankMarket.length; i++) {
            saveBankMarket(
                context,
                _marketId,
                listBankMarket[i].bankName,
                listBankMarket[i].bankNumber,
                listBankMarket[i].bankAccountName,
                null);
          }
          //Navigator.pop(context);
        } else if (_resStatus == 0) {
          ScaffoldMessenger.of(context).showSnackBar(singUpFail);
        }
      });
    });
  }
}

class SaveBankMarket {
  SaveBankMarket(
    this.bankName,
    this.bankNumber,
    this.bankAccountName,
  );

  final bankName;
  final bankNumber;
  final String bankAccountName;
}
