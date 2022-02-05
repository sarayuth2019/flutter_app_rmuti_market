import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/my_shop_tab/my_shop_tab.dart';
import 'package:http/http.dart' as http;

class EditDate extends StatefulWidget {
  EditDate(this.token, this.itemData);

  final token;
  final Item itemData;

  @override
  _EditDateState createState() => _EditDateState(token, itemData);
}

class _EditDateState extends State<EditDate> {
  _EditDateState(this.token, this.itemData);

  final token;
  final Item itemData;
  var dealBegin;
  var dealFinal;
  var dateBegin;
  var dateFinal;

  var _dealFinal;
  var _dealBegin;
  var _dateBegin;
  var _dateFinal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateBegin =
        '${itemData.dateBegin.split('/')[0]}/${itemData.dateBegin.split('/')[1]}/${itemData.dateBegin.split('/')[2]}';
    _dateFinal =
        '${itemData.dateFinal.split('/')[0]}/${itemData.dateFinal.split('/')[1]}/${itemData.dateFinal.split('/')[2]}';
    _dealBegin =
        '${itemData.dealBegin.split('/')[0]}/${itemData.dealBegin.split('/')[1]}/${itemData.dealBegin.split('/')[2]}';
    _dealFinal =
        '${itemData.dealFinal.split('/')[0]}/${itemData.dealFinal.split('/')[1]}/${itemData.dealFinal.split('/')[2]}';

    dateBegin =
        '${itemData.dateBegin.split('/')[1]}/${itemData.dateBegin.split('/')[0]}/${itemData.dateBegin.split('/')[2]}';
    dateFinal =
        '${itemData.dateFinal.split('/')[1]}/${itemData.dateFinal.split('/')[0]}/${itemData.dateFinal.split('/')[2]}';
    dealBegin =
        '${itemData.dealBegin.split('/')[1]}/${itemData.dealBegin.split('/')[0]}/${itemData.dealBegin.split('/')[2]}';
    dealFinal =
        '${itemData.dealFinal.split('/')[1]}/${itemData.dealFinal.split('/')[0]}/${itemData.dealFinal.split('/')[2]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ขยายระยะเวลา',
          style: TextStyle(
              color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                Text('ระยะเวลาการลงทะเบียน'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                      onPressed: () {
                        _pickDealBegin(context);
                      },
                      child: Text('${_dealBegin.toString()}'),
                    ),
                    Text(
                      ' - ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                      onPressed: () {
                        _pickDealFinal(context);
                      },
                      child: Text('${_dealFinal.toString()}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Text('ระยะเวลาการใช้ส่วนลดรับสินค้า'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    onPressed: () {
                      _pickDateBegin(context);
                    },
                    child: Text('${_dateBegin.toString()}'),
                  ),
                  Text(
                    ' - ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    onPressed: () {
                      _pickDateFinal(context);
                    },
                    child: Text('${_dateFinal.toString()}'),
                  ),
                ]),
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.teal),
              onPressed: () {
                showDialogSaveDate();
              },
              child: Text(
                'บันทึก',
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Future _pickDealBegin(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        _dealBegin = '${date!.day}/${date.month}/${date.year}';
        dealBegin = "${date.month}/${date.day}/${date.year}";
        print(dealBegin);
      });
    });
  }

  Future _pickDealFinal(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        _dealFinal = '${date!.day}/${date.month}/${date.year}';
        dealFinal = "${date.month}/${date.day}/${date.year}";
        print(dealFinal);
      });
    });
  }

  Future _pickDateBegin(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        _dateBegin = '${date!.day}/${date.month}/${date.year}';
        dateBegin = "${date.month}/${date.day}/${date.year}";
        print(dateBegin);
      });
    });
  }

  Future _pickDateFinal(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        _dateFinal = '${date!.day}/${date.month}/${date.year}';
        dateFinal = "${date.month}/${date.day}/${date.year}";
        print(dateFinal);
      });
    });
  }

  void showDialogSaveDate() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "บันทึกการขยายเวลา ?",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    onPressed: () {
                      saveToDB(context, token, itemData);
                    },
                    child: Text('บันทึก')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ยกเลิก'))
              ],
            ),
          );
        });
  }

  void saveToDB(context, token, Item itemData) async {
    final urlSellProducts = "${Config.API_URL}/Item/update";
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("กำลังบันทึก กรุณารอซักครู่...")));
    String _textListSize = itemData.size.toString();
    String _textListColors = itemData.colors.toString();
    var textListSize = _textListSize.substring(1, _textListSize.length - 1);
    var textListColors =
        _textListColors.substring(1, _textListColors.length - 1);

    Map params = Map();
    params['itemId'] = itemData.itemID.toString();
    params['marketId'] = itemData.marketID.toString();
    params['nameItems'] = itemData.nameItem.toString();
    params['groupItems'] = itemData.groupItems.toString();
    params['price'] = itemData.price.toString();
    params['priceSell'] = itemData.priceSell.toString();
    params['count'] = itemData.count.toString();
    params['size'] = textListSize.toString();
    params['colors'] = textListColors.toString();
    params['countRequest'] = itemData.countRequest.toString();
    params['dateBegin'] = dateBegin.toString();
    params['dateFinal'] = dateFinal.toString();
    params['dealBegin'] = dealBegin.toString();
    params['dealFinal'] = dealFinal.toString();

    http.post(Uri.parse(urlSellProducts), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      Navigator.of(context).pop();

      Map _resData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      print(_resData);
      var _resStatus = _resData['status'];
      if (_resStatus == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('บันทึกการขยายเวลา สำเร็จ !')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('บันทึกการขยายเวลา ล้มเหลว !')));
      }
    });
  }
}
