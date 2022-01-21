import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/admin/overview_order/table_payment.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_all.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_by_marketId.dart';

class MarketOverViewTab extends StatefulWidget {
  const MarketOverViewTab(this.token, this.marketId);

  final token;
  final int marketId;

  @override
  _MarketOverViewTabState createState() =>
      _MarketOverViewTabState(token, marketId);
}

class _MarketOverViewTabState extends State<MarketOverViewTab> {
  _MarketOverViewTabState(this.token, this.marketId);

  final token;
  final int marketId;

  DateTime dateTimeDayNow = DateTime.now();

  List<String> listDropdownButton = ['วันที่', 'เดือน', 'ปี', 'ทั้งหมด'];
  var _typeDropDownPick;
  var _dropDownPickValue;

  List<Payment> _listTypePayment = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _typeDropDownPick = listDropdownButton[0];
    listAllPaymentData(token).then((value) {
      if (dateTimeDayNow.day.toString().length == 1 &&
          dateTimeDayNow.month.toString().length == 1) {
        _dropDownPickValue =
            '0${dateTimeDayNow.day}/0${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      } else if (dateTimeDayNow.day.toString().length == 1) {
        _dropDownPickValue =
            '0${dateTimeDayNow.day}/${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      } else if (dateTimeDayNow.month.toString().length == 1) {
        _dropDownPickValue =
            '${dateTimeDayNow.day}/0${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      } else {
        _dropDownPickValue =
            '${dateTimeDayNow.day}/${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      }
      _listTypePayment = value
          .where((element) => element.date
              .substring(0, 10)
              .toString()
              .contains(_dropDownPickValue.toString()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          'รายการของ Market Id ${marketId.toString()}',
          style: TextStyle(color: Colors.teal),
        ),
      ),
      body: FutureBuilder(
        future: listPaymentByMarketId(token, marketId),
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshotListPayment) {
          if (snapshotListPayment.data == null || _dropDownPickValue == null) {
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
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              height: 42,
                              decoration: boxDecorationGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      value: _typeDropDownPick,
                                      onChanged: (value) {
                                        setState(() {
                                          this._typeDropDownPick = value;
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
                          Column(
                            children: [
                              Container(
                                child: _typeDropDownPick == 'วันที่'
                                    ? Text(
                                        '${_dropDownPickValue.toString()}',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    : Container(),
                              ),
                              Container(
                                child: _typeDropDownPick == 'เดือน'
                                    ? Text(
                                        '${_dropDownPickValue.toString()}',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    : Container(),
                              ),
                              Container(
                                child: _typeDropDownPick == 'ปี'
                                    ? Text(
                                        '${_dropDownPickValue.toString()}',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                          _typeDropDownPick == 'ทั้งหมด'
                              ? Container()
                              : IconButton(
                                  onPressed: () {
                                    _pickDate(
                                        context, snapshotListPayment.data);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.teal,
                                  ))
                        ],
                      ),
                    ],
                  )),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                              Text('Date',
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
                  TablePayment(_listTypePayment),
                ],
              ),
              bottomSheet: _listTypePayment.length == 0
                  ? Center(child: Text('ไม่พบรายการที่ค้นหา'))
                  : Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('รวมเป็นเงิน :'),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 8.0),
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
      ),
    );
  }

  Future _pickDate(BuildContext context, _listTypePayment) async {
    return showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDatePickerMode: DatePickerMode.year,
            context: context,
            initialDate: dateTimeDayNow,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      if (date != null) {
        setState(() {
          dateTimeDayNow = date;
          checkDropDownPick(_typeDropDownPick, _listTypePayment);
        });
        print(dateTimeDayNow);
      }
    });
  }

  void checkDropDownPick(value, List<Payment> listPayment) {
    if (value == 'ทั้งหมด') {
      print(_typeDropDownPick.toString());
      _listTypePayment = listPayment;
      ///////ดูรายการของ วันนี้//////////////
    } else if (value == 'วันที่') {
      //dateTimeDayNow = DateTime.now();
      print(_typeDropDownPick.toString());
      if (dateTimeDayNow.day.toString().length == 1 &&
          dateTimeDayNow.month.toString().length == 1) {
        _dropDownPickValue =
            '0${dateTimeDayNow.day}/0${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      } else if (dateTimeDayNow.day.toString().length == 1) {
        _dropDownPickValue =
            '0${dateTimeDayNow.day}/${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      } else if (dateTimeDayNow.month.toString().length == 1) {
        _dropDownPickValue =
            '${dateTimeDayNow.day}/0${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      } else {
        _dropDownPickValue =
            '${dateTimeDayNow.day}/${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      }
      //print(_dropDownPick);
      //print(listPayment[0].date.substring(0, 10));
      _listTypePayment = listPayment
          .where((element) => element.date
              .substring(0, 10)
              .toString()
              .contains(_dropDownPickValue.toString()))
          .toList();
      ///////ดูรายการของ เดือนนี้//////////////
    } else if (value == 'เดือน') {
      print(_typeDropDownPick.toString());
      if (dateTimeDayNow.month.toString().length == 1) {
        _dropDownPickValue = '0${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      } else {
        _dropDownPickValue = '${dateTimeDayNow.month}/${dateTimeDayNow.year}';
      } //print(listPayment[1].date.substring(3,10));
      _listTypePayment = listPayment
          .where((element) => element.date
              .substring(3, 10)
              .toString()
              .contains(_dropDownPickValue.toString()))
          .toList();
      ///////ดูรายการของ ปีนี้//////////////
    } else if (value == 'ปี') {
      print(_typeDropDownPick.toString());
      _dropDownPickValue = '${dateTimeDayNow.year}';
      //print(listPayment[1].date.split('/')[2]);
      _listTypePayment = listPayment
          .where((element) => element.date
              .split('/')[2]
              .toString()
              .contains(_dropDownPickValue.toString()))
          .toList();
    }
  }
}
