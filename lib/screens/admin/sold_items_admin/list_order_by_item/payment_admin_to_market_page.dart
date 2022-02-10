import 'dart:convert';
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_item_by_itemId.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_admin_by_itemId.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_bankmarket.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_status_payment_admin.dart';
import 'package:image_picker/image_picker.dart';

class PaymentAminToMarket extends StatefulWidget {
  PaymentAminToMarket(this.token, this.adminId, this.listOrders,
      this.listOrderDetail, this.itemData);

  final token;
  final adminId;
  final listOrders;
  final listOrderDetail;
  final itemData;

  @override
  _PaymentAminToMarketState createState() => _PaymentAminToMarketState(
      token, adminId, listOrders, listOrderDetail, itemData);
}

class _PaymentAminToMarketState extends State<PaymentAminToMarket> {
  _PaymentAminToMarketState(this.token, this.adminId, this.listOrders,
      this.listOrderDetail, this.itemId);

  final token;
  final adminId;
  final listOrders;
  final listOrderDetail;
  final Items itemId;

  String statusPaymentAdmin = 'รอตรวจสอบจากร้านค้า';

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
  int? amount;
  String? dataTransfer;
  String? _bankTransferValue;
  String? _bankReceiveValue;
  String? _dateTransfer;
  String? _timeTransfer;
  //int? _lastNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.teal),
        ),
        body: FutureBuilder(
          future: getPaymentAdminByItemId(token, listOrders[0].itemId),
          builder: (BuildContext context,
              AsyncSnapshot<dynamic> snapshotPaymentAdmin) {
            if (snapshotPaymentAdmin.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
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
                          ' ${listOrders.map((e) => e.priceSell).reduce((value, element) => value + element)} ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          'บาท',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Text(
                      'ชำระเงินผ่านทาง',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    FutureBuilder(
                      future: listBankMarket(token, listOrders[0].marketId),
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
                          amount = listOrders
                              .map((e) => e.priceSell)
                              .reduce((a, b) => a + b);
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${snapshotBankMarket.data[index].nameBank.toString()}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                'ชื่อบัญชี : ${snapshotBankMarket.data[index].bankAccountName.toString()}',
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: (Colors
                                                                    .teal)),
                                                        onPressed: () {
                                                          FlutterClipboard.copy(
                                                                  snapshotBankMarket
                                                                      .data[
                                                                          index]
                                                                      .bankNumber
                                                                      .toString())
                                                              .then((value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('Copy Bank Number !')));
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'โอนจากธนาคาร',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton(
                                      value: _bankTransferValue,
                                      iconEnabledColor: Colors.black,
                                      isExpanded: true,
                                      underline: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black54)),
                                      ),
                                      hint: Text('เลือกธนาคาร'),
                                      items: _listTransferBankName
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton(
                                      value: _bankReceiveValue,
                                      iconEnabledColor: Colors.black,
                                      isExpanded: true,
                                      underline: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black54)),
                                      ),
                                      hint: Text('เลือกธนาคาร'),
                                      items: _listReceiveBankName
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                            '${amount.toString()}',
                                            style: TextStyle(fontSize: 16),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text('เลขบัญชี : '),
                                        Text('xxxxxx '),
                                        Text(
                                          'xxxx',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    /*
                                    Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: boxDecorationGrey,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            _lastNumber = int.parse(value);
                                            print(
                                                'เลขท้าย บช. : ${_lastNumber.toString()}');
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'เลขท้ายบัญชี 4 ตัว',
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),

                                     */
                                    SizedBox(height: 10),
                                    Center(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.teal),
                                          onPressed: () {
                                            checkNullData(
                                                snapshotPaymentAdmin.data);
                                          },
                                          child: Text('บันทึกการโอนเงิน')),
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
              );
            }
          },
        ));
  }

  void checkNullData(paymentAdminData) {
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
    }
    /*
    else if (_lastNumber == null || _lastNumber.toString().length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณากรอกเลขท้ายบัญชีธนาคาร 4 ตัว')));
    }
     */

    else if (imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเพิ่มภาพสลิปการโอนเงิน')));
    } else {
      print('PayId : ${paymentAdminData.payId}');
      print(
          'ธนาคารที่โอน : ${_bankTransferValue.toString()} ==> ${_bankReceiveValue.toString()}');
      print('วันที่ : ${_dateTransfer.toString()}');
      print('เวลา : ${_timeTransfer.toString()}');
      print('จำนวนเงิน : ${amount.toString()}');
      //print('เลขท้าย บช : ${_lastNumber.toString()}');
      ///////////////////////// บันทึกสถานะการโอนเงินของ admin ===> market //////////////////////////
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กำลังบันทึก...')));

      saveStatusPaymentAdmin(
          context,
          token,
          paymentAdminData,
          adminId,
          'จำนวนคนทะเบียน : ${itemId.count}/${itemId.countRequest}',
          _bankTransferValue,
          _bankReceiveValue,
          _dateTransfer,
          _timeTransfer,
          amount,
          statusPaymentAdmin,
          imageFile);
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

  Future _pickTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    showTimePicker(context: context, initialTime: initialTime).then((value) {
      setState(() {
        _timeTransfer = '${value!.hour}:${value.minute}';
      });
    });
  }
}
