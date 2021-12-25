import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/admin/overview_order/table_payment.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_all.dart';

class AdminOverViewTab extends StatefulWidget {
  const AdminOverViewTab(this.token);

  final token;


  @override
  _AdminOverViewTabState createState() => _AdminOverViewTabState(token);
}

class _AdminOverViewTabState extends State<AdminOverViewTab> {
  _AdminOverViewTabState(this.token);

  final token;


  DateTime dateTimeDayNow = DateTime.now();

  List<String> listDropdownButton = [
    'ทั้งหมด',
    'วันนี้',
    'เดือนนี้',
    'ปีนี้',
    'ระบุวันที่'
  ];
  var _dropDownValue;
  var _dropDownPick;

  List<Payment> _listTypePayment = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropDownValue = listDropdownButton[0];
    listAllPaymentData(token).then((value) {
      _listTypePayment = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listAllPaymentData(token),
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshotListPayment) {
        if (snapshotListPayment.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          height: 42,
                          decoration: boxDecorationGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  value: _dropDownValue,
                                  onChanged: (value) {
                                    setState(() {
                                      this._dropDownValue = value;
                                      checkDropDownPick(
                                          value, snapshotListPayment.data);
                                    });
                                  },
                                  items: listDropdownButton
                                      .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text('${e.toString()}')))
                                      .toList()),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          child: _dropDownPick == 'ระบุวันที่'
                              ? Container(
                                  height: 42,
                                  width: 130,
                                  decoration: boxDecorationGrey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextField(
                                      onChanged: (String dateSearch) {
                                        // print('date Search : ${dateSearch.toString()}');
                                        setState(() {
                                          _listTypePayment = snapshotListPayment
                                              .data
                                              .where((element) => element.date
                                                  .toString()
                                                  .contains(
                                                      dateSearch.toString()))
                                              .toList();
                                        });
                                      },
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                          hintText: 'วัน/เดือน/ปี',
                                          border: InputBorder.none),
                                    ),
                                  ))
                              : Text(
                                  '${dateTimeDayNow.day}/${dateTimeDayNow.month}/${dateTimeDayNow.year}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17),
                                ))
                    ],
                  ),
                ],
              ),
              bottom: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Container(
                  decoration: boxDecorationGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      children: [
                        TableRow(children: [
                          Text('Payment Id',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14)),
                          Text('จำนวนเงิน',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14)),
                          Text('Status',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14)),
                        ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TablePayment(_listTypePayment),
            bottomSheet: _listTypePayment.length == 0
                ? Center(child: Text('ไม่พบรายการที่ค้นหา'))
                : Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('รวมเป็นเงิน :'),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: Text(
                              '${_listTypePayment.map((e) => e.amount).reduce((a, b) => a + b)}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Text('บาท'),
                      ],
                    ),
                  ),
          );
        }
      },
    );
  }

  void checkDropDownPick(value, List<Payment> listPayment) {
    if (value == 'ทั้งหมด') {
      _listTypePayment = listPayment;
    } else if (value == 'วันนี้') {
      _dropDownPick = '${dateTimeDayNow.day}';
      _listTypePayment = listPayment
          .where((element) => element.date
              .split('/')[0]
              .toString()
              .contains(_dropDownPick.toString()))
          .toList();
    } else if (value == 'เดือนนี้') {
      _dropDownPick = '${dateTimeDayNow.month}';
      _listTypePayment = listPayment
          .where((element) => element.date
              .split('/')[1]
              .toString()
              .contains(_dropDownPick.toString()))
          .toList();
    } else if (value == 'ปีนี้') {
      _dropDownPick = '${dateTimeDayNow.year}';
      _listTypePayment = listPayment
          .where((element) => element.date
              .split('/')[2]
              .toString()
              .contains(_dropDownPick.toString()))
          .toList();
    } else if (value == 'ระบุวันที่') {
      _dropDownPick = value;
      print(_dropDownPick);
    }
  }
}
