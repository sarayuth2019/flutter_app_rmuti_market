import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_bankmarket.dart';
import 'package:http/http.dart' as http;

void showDialogEditBankMarket(context, token, BankMarket bankMarketData) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowDialogListBank(token, bankMarketData);
      });
}

class ShowDialogListBank extends StatefulWidget {
  ShowDialogListBank(this.token, this.bankMarketData);

  final token;
  final BankMarket bankMarketData;

  @override
  _ShowDialogListBankState createState() =>
      _ShowDialogListBankState(token, bankMarketData);
}

class _ShowDialogListBankState extends State<ShowDialogListBank> {
  _ShowDialogListBankState(this.token, this.bankMarketData);

  final token;
  final BankMarket bankMarketData;

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

  String? _bankName;
  String? _bankNumber;
  String? _bankAccountName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bankName = bankMarketData.nameBank;
    _bankNumber = bankMarketData.bankNumber;
    _bankAccountName = bankMarketData.bankAccountName;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ธนาคาร',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
            ),
            DropdownButton(
              value: _bankName,
              iconEnabledColor: Colors.black,
              isExpanded: true,
              underline: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black54)),
              ),
              hint: Text('เลือกธนาคาร'),
              items:
                  _listBankName.map<DropdownMenuItem<String>>((String value) {
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
            SizedBox(
              height: 8,
            ),
            Text(
              'เลขบัญชี',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
            ),
            Container(
              decoration: boxDecorationGrey,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: TextField(
                  controller: TextEditingController(text: _bankNumber),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: _bankName == "พร้อมเพย์"
                          ? 'เบอร์ พร้อมเพย์ (ไม่ต้องเว้นวรรค)'
                          : 'เลขบัญชี (ไม่ต้องเว้นวรรค)',
                      border: InputBorder.none),
                  onChanged: (text) {
                    _bankNumber = text;
                    print(_bankNumber);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'ชื่อบัญชี',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
            ),
            Container(
              decoration: boxDecorationGrey,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: TextField(
                  controller: TextEditingController(text: _bankAccountName),
                  decoration: InputDecoration(
                      hintText: 'ชื่อบัญชี', border: InputBorder.none),
                  onChanged: (text) {
                    _bankAccountName = text;
                    print(_bankAccountName);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.teal),
                      onPressed: () {
                        editBankMarket(context, token, bankMarketData,
                            _bankName, _bankAccountName, _bankNumber);
                      },
                      child: Text('บันทึก')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('กลับ'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void editBankMarket(context, token, BankMarket bankMarketData, nameBank,
      bankAccountName, bankNumber) async {
    String urlEditBankMarket =
        '${Config.API_URL}/BankMarket/update/${bankMarketData.bankMarketId}';
    Map params = Map();
    params['bankMarketId'] = bankMarketData.bankMarketId.toString();
    params['marketId'] = bankMarketData.marketId.toString();
    params['nameBank'] = nameBank.toString();
    params['bankAccountName'] = bankAccountName.toString();
    params['bankNumber'] = bankNumber.toString();

    await http.post(Uri.parse(urlEditBankMarket), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);
      var resData = jsonDecode(utf8.decode(res.bodyBytes));
      var status = resData['status'];
      if (status == 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('แก้ไข สำเร็จ')));
        Navigator.pop(context);
      }
    });
  }
}
