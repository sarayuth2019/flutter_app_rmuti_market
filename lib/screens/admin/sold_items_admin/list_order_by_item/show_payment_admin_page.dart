import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/get_Image_payment_method.dart';

class ShowPaymentAdminPage extends StatelessWidget {
  ShowPaymentAdminPage(this.token, this.paymentAdminData);

  final token;
  final paymentAdminData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4.0, left: 4.0),
                                    child: Container(
                                      height: 300,
                                      width: 240,
                                      child: Image.memory(
                                        base64Decode(snapshotImage.data[index]),
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
                        child: Text('หมายเหตุ* : ${paymentAdminData.detail}')),
                  ],
                ),
              ),
            ),
            paymentAdminData.status == 'ชำระเงินสำเร็จ'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.green,
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
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.amber,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'สถานะ : ${paymentAdminData.status}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      )),
    );
  }
}
