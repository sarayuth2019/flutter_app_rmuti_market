import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_Image_payment_method.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_payment_admin_by_itemId.dart';
import 'package:flutter_app_rmuti_market/screens/method/save_status_payment_admin.dart';

class MarketPaymentAdminPage extends StatefulWidget {
  MarketPaymentAdminPage(this.token, this.paymentAdminData);

  final token;
  final paymentAdminData;

  @override
  _MarketPaymentAdminPageState createState() =>
      _MarketPaymentAdminPageState(token, paymentAdminData);
}

class _MarketPaymentAdminPageState extends State<MarketPaymentAdminPage> {
  _MarketPaymentAdminPageState(this.token, this.paymentAdminData);

  final token;
  final PaymentAdmin paymentAdminData;

  String? detail;

  Future<void> _reFreshPage() async {
    setState(() {
      print('ReFreshPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _reFreshPage,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'PaymentAdminId : ${paymentAdminData.payId}',
            style: TextStyle(color: Colors.teal, fontSize: 15),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.teal),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('สถานะ : ${paymentAdminData.status}'),
              ),

               */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: boxDecorationGrey,
                      height: 400,
                      width: 250,
                      child: FutureBuilder(
                        future: getImagePayment(token, paymentAdminData.payId),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshotImage) {
                          if (snapshotImage.data == null) {
                            return Container(
                                decoration: boxDecorationGrey,
                                child: Center(child: Text('กำลังโหลดสลีป...')));
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 310,
                                width: double.infinity,
                                child: ListView.builder(
                                  //shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshotImage.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4.0, left: 4.0),
                                      child: Container(
                                        height: 300,
                                        width: 240,
                                        child: Image.memory(
                                          base64Decode(
                                              snapshotImage.data[index]),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: boxDecorationGrey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ธนาคารที่โอน : ${paymentAdminData.bankTransfer}'),
                      Text('ธนาคารที่รับ : ${paymentAdminData.bankReceive}'),
                      Text('จำนวนเงิน : ${paymentAdminData.amount} บาท'),
                      Text('วันที่โอน : ${paymentAdminData.date}'),
                      Text('เวลาที่โอน : ${paymentAdminData.time}'),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child:
                              Text('หมายเหตุ* : ${paymentAdminData.detail}')),
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future: getPaymentAdminByItemId(token, paymentAdminData.itemId),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshotPaymentAdmin) {
                  if (snapshotPaymentAdmin.data == null) {
                    return Center(
                      child: Text('กำลังโหลด...'),
                    );
                  } else {
                    return snapshotPaymentAdmin.data.status ==
                            'รอตรวจสอบจากร้านค้า'
                        ? Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.teal),
                                  onPressed: () {
                                    print(
                                        '=======================> จำนวนเงินถูกต้อง');
                                    _showDialogGetMoney(snapshotPaymentAdmin.data,'ชำระเงินสำเร็จ');
                                  },
                                  child: Text('จำนวนเงินถูกต้อง')),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey),
                                  onPressed: () {
                                    print(
                                        '=======================> จำนวนเงินผิดพลาด');
                                    _showDialogGetMoney(snapshotPaymentAdmin.data,'ชำระเงินผิดพลาด');
                                  },
                                  child: Text('จำนวนเงินผิดพลาด'))
                            ],
                          )
                        : snapshotPaymentAdmin.data.status == 'ชำระเงินสำเร็จ'
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Colors.green,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'สถานะ : ${snapshotPaymentAdmin.data.status}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Colors.red,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'สถานะ : ${snapshotPaymentAdmin.data.status}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '* รอแอดมินทำการแก้ไข',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                  }
                },
              )
            ],
          ),
        )),
      ),
    );
  }

  void _showDialogGetMoney(PaymentAdmin paymentAdmin,String status) async {
    detail = paymentAdmin.detail.toString();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('การ${status.toString()} ?'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  status == 'ชำระเงินผิดพลาด'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'หมายเหตุ *',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: TextEditingController(text: paymentAdmin.detail),
                              maxLines: null,
                              onChanged: (value) {
                                detail = value.toString();
                                print('${detail.toString()}');
                              },
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('ยืนยันการรับเงิน'),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.teal),
                          onPressed: () {
                            print(
                                '=======================> ${status.toString()}');
                            setState(() {
                              marketSaveStatusPaymentAdmin(
                                  context, token, paymentAdminData, status,detail,_reFreshPage);
                            });
                          },
                          child: Text('ยืนยัน')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('กลับ')),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
