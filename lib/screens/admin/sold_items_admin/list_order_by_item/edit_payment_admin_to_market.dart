import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_Image_payment_method.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_admin_by_itemId.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_bankmarket.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_status_payment_admin.dart';
import 'package:image_picker/image_picker.dart';

class EditPaymentAdminToMarket extends StatefulWidget {
  EditPaymentAdminToMarket(this.token, this.adminId, this.paymentAdminData);

  final token;
  final adminId;
  final paymentAdminData;

  @override
  _EditPaymentAdminToMarketState createState() =>
      _EditPaymentAdminToMarketState(token, adminId, paymentAdminData);
}

class _EditPaymentAdminToMarketState extends State<EditPaymentAdminToMarket> {
  _EditPaymentAdminToMarketState(
      this.token, this.adminId, this.paymentAdminData);

  final token;
  final adminId;
  final PaymentAdmin paymentAdminData;

  List<String> _listTransferBankName = [
    'ธนาคารไทยพาณิชย์ SCB',
    'ธนาคารกรุงเทพ BBL',
    'ธนาคารกสิกรไทย KBANK',
    'ธนาคารกรุงไทย KTB',
    'ธนาคารกรุงศรีอยุธยา BAY',
    'ธนาคารทหารไทยธนชาต TTB',
    'ธนาคารออมสิน GSB',
    'ธนาคารอิสลามแห่งประเทศไทย ISBT'
  ];
  List<String> _listReceiveBankName = [];

  File? imageFile;
  String? imageData;
  String? dataTransfer;
  String? _bankTransferValue;
  String? _bankReceiveValue;
  String? _dateTransfer;
  String? _timeTransfer;

  String? detail;
  TextEditingController? textDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detail = paymentAdminData.detail;
    textDetail = TextEditingController(text: paymentAdminData.detail);
    _bankTransferValue = paymentAdminData.bankTransfer;
    _bankReceiveValue = paymentAdminData.bankReceive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ราคาสินค้า',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  ' ${paymentAdminData.amount} ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'บาท',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Text(
              'ชำระเงินผ่านทาง',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            FutureBuilder(
              future: listBankMarket(token, paymentAdminData.marketId),
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshotBankMarket) {
                if (snapshotBankMarket.data == null) {
                  return Text('กำลังโหลด...');
                } else {
                  List<String> _listBankName = [];
                  snapshotBankMarket.data.forEach((e) {
                    _listBankName.add(e.nameBank);
                  });
                  _listReceiveBankName = _listBankName;
                  return Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshotBankMarket.data.length,
                          itemBuilder: (BuildContext context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${snapshotBankMarket.data[index].nameBank.toString()}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'ชื่อบัญชี : ${snapshotBankMarket.data[index].bankAccountName.toString()}',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        Text(
                                          'เลขบัญชี : ${snapshotBankMarket.data[index].bankNumber}',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: (Colors.teal)),
                                                onPressed: () {
                                                  FlutterClipboard.copy(
                                                          snapshotBankMarket
                                                              .data[index]
                                                              .bankNumber
                                                              .toString())
                                                      .then((value) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                'Copy Bank Number !')));
                                                  });
                                                },
                                                child: Text('copy')))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      Container(
                        height: 320,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ShowListImagePaymentAdmin(
                                  token, paymentAdminData.payId),
                              GestureDetector(
                                onTap: () {
                                  _onGallery();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: boxDecorationGrey,
                                      height: 300,
                                      width: 190,
                                      child: imageFile == null
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.add),
                                                  Text('เพิ่มภาพสลิปจ่ายเงิน'),
                                                ],
                                              ),
                                            )
                                          : Center(
                                              child: Container(
                                                height: 300,
                                                width: 190,
                                                child: Image.file(
                                                  imageFile!,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'โอนจากธนาคาร',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton(
                              value: _bankTransferValue,
                              iconEnabledColor: Colors.black,
                              isExpanded: true,
                              underline: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54)),
                              ),
                              hint: Text('เลือกธนาคาร'),
                              items: _listTransferBankName
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                  _bankTransferValue = value as String?;
                                });
                              },
                            ),
                            Text(
                              'โอนไปยังธนาคาร',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton(
                              value: _bankReceiveValue,
                              iconEnabledColor: Colors.black,
                              isExpanded: true,
                              underline: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54)),
                              ),
                              hint: Text('เลือกธนาคาร'),
                              items: _listReceiveBankName
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                  _bankReceiveValue = value as String?;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                _pickDate(context);
                              },
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: boxDecorationGrey,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'วันที่โอนเงิน',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                        child: _dateTransfer == null
                                            ? Text('เดือน-วัน-ปี')
                                            : Text(
                                                '${_dateTransfer.toString()}')),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                _pickTime(context);
                              },
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: boxDecorationGrey,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'เวลาที่โอนเงิน',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                        child: _timeTransfer == null
                                            ? Text('ชม:นาที')
                                            : Text(
                                                '${_timeTransfer.toString()}')),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('จำนวนเงิน : บาท'),
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: boxDecorationGrey,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Text(
                                    '${paymentAdminData.amount.toString()}',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('หมายเหตุ * '),
                            Container(
                              width: double.infinity,
                              decoration: boxDecorationGrey,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: TextField(
                                  controller: TextEditingController(
                                      text: paymentAdminData.detail),
                                  maxLines: null,
                                  onChanged: (value) {
                                    detail = value;
                                    print('detail : ${detail.toString()}');
                                  },
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            paymentAdminData.status == "ชำระเงินผิดพลาด"
                                ? Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.teal),
                                        onPressed: () {
                                          checkNullData(paymentAdminData,
                                              'รอตรวจสอบจากร้านค้า');
                                        },
                                        child: Text('บันทึกการโอนเงิน')),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: Colors.amber,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'สถานะ : ${paymentAdminData.status}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void checkNullData(PaymentAdmin paymentAdminData, statusPaymentAdmin) {
    if (_bankTransferValue == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเลือกธนาคารที่โอนเงิน')));
    } else if (_bankReceiveValue == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเลือกธนาคารที่รับเงิน')));
    } else if (_dateTransfer == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเพิ่มวันที่โอนเงิน')));
    } else if (_timeTransfer == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเพิ่มเวลาที่โอนเงิน')));
    } else if (imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเพิ่มภาพสลิปการโอนเงิน')));
    } else {
      print('PayId : ${paymentAdminData.payId}');
      print(
          'ธนาคารที่โอน : ${_bankTransferValue.toString()} ==> ${_bankReceiveValue.toString()}');
      print('วันที่ : ${_dateTransfer.toString()}');
      print('เวลา : ${_timeTransfer.toString()}');
      print('จำนวนเงิน : ${paymentAdminData.amount.toString()}');
      //print('เลขท้าย บช : ${_lastNumber.toString()}');
      ///////////////////////// บันทึกสถานะการโอนเงินของ admin ===> market //////////////////////////
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กำลังบันทึก...')));

      setState(() {
        saveStatusPaymentAdmin(
            context,
            token,
            paymentAdminData,
            adminId,
            detail,
            _bankTransferValue,
            _bankReceiveValue,
            _dateTransfer,
            _timeTransfer,
            paymentAdminData.amount,
            statusPaymentAdmin,
            imageFile);
      });
    }
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
      return imageData;
    } else {
      return null;
    }
  }

  Future _pickTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    showTimePicker(context: context, initialTime: initialTime).then((value) {
      setState(() {
        _timeTransfer = '${value!.hour}:${value.minute}';
      });
    });
  }

  Future _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        _dateTransfer = "${date!.month}/${date.day}/${date.year}";
        print(date);
      });
    });
  }
}

class ShowListImagePaymentAdmin extends StatefulWidget {
  ShowListImagePaymentAdmin(this.token, this.paymentAdminId);

  final token;
  final paymentAdminId;

  @override
  _ShowListImagePaymentAdminState createState() =>
      _ShowListImagePaymentAdminState(token, paymentAdminId);
}

class _ShowListImagePaymentAdminState extends State<ShowListImagePaymentAdmin> {
  _ShowListImagePaymentAdminState(this.token, this.paymentAdminId);

  final token;
  final paymentAdminId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImagePayment(token, paymentAdminId),
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshotImagePayment) {
        if (snapshotImagePayment.data == null) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: boxDecorationGrey,
                height: 300,
                width: 190,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
          );
        } else {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: snapshotImagePayment.data.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 300,
                      width: 190,
                      child: Image.memory(
                        base64Decode(snapshotImagePayment.data[index]),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}
