import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/account_Market_Page/market_page.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;

void saveBankMarket(
  context,
  int marketId,
  String bankName,
  bankNumber,
  String bankAccountName,
) async {
  print('marketId : ${marketId.toString()}');
  print('bankName : ${bankName.toString()}');
  print('bankNumber : ${bankNumber.toString()}');
  print('bankAccountName : ${bankAccountName.toString()}');

  String urlSaveBankMarket = '${Config.API_URL}/BankMarket/save';
  Map params = Map();
  params['marketId'] = marketId.toString();
  params['nameBank'] = bankName.toString();
  params['bankNumber'] = bankNumber.toString();
  params['bankAccountName'] = bankAccountName.toString();

  await http.post(Uri.parse(urlSaveBankMarket), body: params).then((res) {
    //print(res.body);
    final resData = jsonDecode(res.body);
    var status = resData['status'];
    if (status == 1) {
      //print(data);
      Navigator.pop(context);
    } else {
      print(res.body);
      print('Save BankMarket Fall !!!!!!');
    }
  });
}

void showAddBankMarket(context, marketData) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBankMarketDialog(marketData);
      });
}

class AddBankMarketDialog extends StatefulWidget {
  AddBankMarketDialog(this.marketData);

  final MarketData marketData;

  @override
  _AddBankMarketDialogState createState() =>
      _AddBankMarketDialogState(marketData);
}

class _AddBankMarketDialogState extends State<AddBankMarketDialog> {
  _AddBankMarketDialogState(this.marketData);

  final MarketData marketData;

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
                        saveBankMarket(context, marketData.marketID!,
                            _bankName!, _bankNumber, _bankAccountName!);
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
}
