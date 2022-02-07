import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:flutter_app_rmuti_market/screens/account/my_shop_tab/my_shop_tab.dart';
import 'package:flutter_app_rmuti_market/screens/method/boxdecoration_stype.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  EditProductPage(this.itemData, this.token);

  final itemData;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditProductPage(itemData, token);
  }
}

class _EditProductPage extends State {
  _EditProductPage(this.itemData, this.token);

  final Item itemData;
  final token;

  List? _resImageData;
  List? _resIdData;
  List? _listImageShow;
  List _listFileAddImage = [];
  List _listByteAddImage = [];
  List _listDeleteImage = [];
  List _listDefaultImage = [];
  bool? chekButton;

  int? marketID;
  String? nameItem;
  int? price;
  int? priceSell;
  int? count;
  int? countRequest;
  File? imageFile;
  String? dealBegin;
  String? dealFinal;
  String? dateBegin;
  String? dateFinal;
  String? _textDealBegin;
  String? _textDealFinal;
  String? _textDateBegin;
  String? _textDateFinal;
  final snackBarOnSave =
      SnackBar(content: Text("กำลังแก้ไขสินค้า กรุณารอซักครู่..."));
  final snackBarOnSaveSuccess = SnackBar(content: Text("แก้ไขสินค้า สำเร็จ !"));
  final snackBarSaveFail = SnackBar(content: Text("แก้ไขสินค้า ล้มเหลว !"));
  final snackBarNoHaveImage =
      SnackBar(content: Text("ต้องใส่รูปอย่างน้อย 1 รูป !"));
  final urlSellProducts = "${Config.API_URL}/Item/update";
  final urlGetImageByItemId = "${Config.API_URL}/images/";
  final urlDeleteItem = "${Config.API_URL}/Item/delete/";
  final urlDeleteImage = "${Config.API_URL}/images/deleteItemId";
  final urlSaveImage = "${Config.API_URL}/images/save";
  final urlDeleteImageByImageId = "${Config.API_URL}/images/deleteId/";

  TextEditingController textSizeName = TextEditingController();
  TextEditingController textSizePrice = TextEditingController();
  TextEditingController textColorName = TextEditingController();
  TextEditingController textColorPrice = TextEditingController();
  bool _showAddDetails = false;
  List listSize = [];
  List listColor = [];
  String? textListSize;
  String? textListColors;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSize = itemData.size;
    listColor = itemData.colors;
    String _textListSize = itemData.size.toString();
    String _textListColors = itemData.colors.toString();

    listSize.removeWhere((value) => value == 'null');
    listColor.removeWhere((value) => value == 'null');

    var _dateBegin =
        '${itemData.dateBegin.split('/')[1]}/${itemData.dateBegin.split('/')[0]}/${itemData.dateBegin.split('/')[2]}';
    var _dateFinal =
        '${itemData.dateFinal.split('/')[1]}/${itemData.dateFinal.split('/')[0]}/${itemData.dateFinal.split('/')[2]}';
    var _dealBegin =
        '${itemData.dealBegin.split('/')[1]}/${itemData.dealBegin.split('/')[0]}/${itemData.dealBegin.split('/')[2]}';
    var _dealFinal =
        '${itemData.dealFinal.split('/')[1]}/${itemData.dealFinal.split('/')[0]}/${itemData.dealFinal.split('/')[2]}';

    _textDealBegin = '${itemData.dealBegin.split('/')[0]}/${itemData.dealBegin.split('/')[1]}/${itemData.dealBegin.split('/')[2]}';
    _textDealFinal = '${itemData.dealFinal.split('/')[0]}/${itemData.dealFinal.split('/')[1]}/${itemData.dealFinal.split('/')[2]}';
    _textDateBegin = '${itemData.dateBegin.split('/')[0]}/${itemData.dateBegin.split('/')[1]}/${itemData.dateBegin.split('/')[2]}';
    _textDateFinal = '${itemData.dateFinal.split('/')[0]}/${itemData.dateFinal.split('/')[1]}/${itemData.dateFinal.split('/')[2]}';




    marketID = itemData.marketID;
    nameItem = itemData.nameItem;
    price = itemData.price;
    priceSell = itemData.priceSell;
    count = itemData.count;
    countRequest = itemData.countRequest;
    dealBegin = _dealBegin;
    dealFinal = _dealFinal;
    dateBegin = _dateBegin;
    dateFinal = _dateFinal;
    textListSize = _textListSize.substring(1, _textListSize.length - 1);
    textListColors = _textListColors.substring(1, _textListColors.length - 1);


    print('list size : ${listSize}');
    print('list color : ${listColor}');


    getImage(itemData.itemID).then((value) {
      if (value.length != 0) {
        setState(() {
          _listImageShow = value;
          _listDefaultImage = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Edit Product ID",
            style: TextStyle(color: Colors.teal),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _onDeleteItem(context);
                },
                icon: Icon(Icons.delete_forever))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    child: _listImageShow != null
                        ? Column(
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: boxDecorationGrey,
                                child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                      initialPage: 0,
                                      enlargeCenterPage: true,
                                      autoPlay: false),
                                  itemCount: _listImageShow!.length,
                                  itemBuilder: (BuildContext context, int index,
                                      int realIndex) {
                                    return Container(
                                        child: _listImageShow!.length == 0
                                            ? Container(
                                                child: Center(
                                                    child:
                                                        Text('กรุณาเพิ่มภาพ')))
                                            : Stack(
                                                children: [
                                                  Container(
                                                      height: 150,
                                                      width: double.infinity,
                                                      child: Image.memory(
                                                        base64Decode(
                                                            _listImageShow![
                                                                index]),
                                                        fit: BoxFit.fill,
                                                      )),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          _onDeleteShowImageList(
                                                              index);
                                                        },
                                                        icon: Icon(
                                                          Icons.remove_circle,
                                                          color: Colors.red,
                                                        )),
                                                  ),
                                                ],
                                              ));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _showAlertSelectImage(context);
                                  },
                                  child: Container(
                                    decoration: boxDecorationGrey,
                                    height: 50,
                                    width: 120,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.add),
                                          Text("เพิ่มรูปภาพ")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(
                            height: 150,
                            width: double.infinity,
                            decoration: boxDecorationGrey,
                            child: Center(child: Text('กำลังโหลดภาพ...')),
                          )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อสินค้า'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: TextField(
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              controller: TextEditingController(text: nameItem),
                              onChanged: (text) {
                                nameItem = text;
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ราคาลด'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(
                                text: priceSell.toString()),
                            onChanged: (num) {
                              priceSell = int.parse(num);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ราคาปกติ'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            keyboardType: TextInputType.number,
                            controller:
                                TextEditingController(text: price.toString()),
                            onChanged: (num) {
                              price = int.parse(num);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('จำนวนคนที่ต้องการ'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(
                                text: countRequest.toString()),
                            onChanged: (num) {
                              countRequest = int.parse(num);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'รายละเดียดเพิ่มเติม',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '(สำหรับการขายเสื้อแบบกลุ่มหรืออื่นๆ)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                    child: _showAddDetails == false
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _showAddDetails = true;
                              });
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.teal,
                            ))
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: boxDecorationGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ขนาด',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            height: 40,
                                            width: double.infinity,
                                            child: listSize.length == 0 ||
                                                    textListSize == 'null'
                                                ? Text('ไม่มีข้อมูลขนาด')
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: listSize.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            index) {
                                                      return Card(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  '${listSize[index].split(':')[0]} : +${listSize[index].split(':')[1]}'),
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      listSize.removeAt(
                                                                          index);
                                                                      print(
                                                                          'listSing length : ${listSize.length}');
                                                                      String
                                                                          _textListSize =
                                                                          listSize
                                                                              .toString();
                                                                      textListSize =
                                                                          _textListSize.substring(
                                                                              1,
                                                                              _textListSize.length - 1);
                                                                      print(
                                                                          listSize);
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .highlight_remove,
                                                                    size: 15,
                                                                    color: Colors
                                                                        .red,
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                          ),
                                          Row(
                                            children: [
                                              Text('ขนาด : '),
                                              Container(
                                                  decoration: boxDecorationGrey,
                                                  height: 30,
                                                  width: 70,
                                                  child: TextField(
                                                    controller: textSizeName,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                  )),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text('ราคาบวกเพิ่ม : '),
                                              Container(
                                                  decoration: boxDecorationGrey,
                                                  height: 30,
                                                  width: 70,
                                                  child: TextField(
                                                    controller: textSizePrice,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                  )),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Container(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.teal),
                                                  onPressed: () {
                                                    String _textSizeName =
                                                        textSizeName.text
                                                            .toString();
                                                    int _textSizePrice =
                                                        int.parse(
                                                            textSizePrice.text);
                                                    setState(() {
                                                      listSize.add(
                                                          '${_textSizeName}:${_textSizePrice}');
                                                      String _textListSize =
                                                          listSize.toString();
                                                      textListSize =
                                                          _textListSize.substring(
                                                              1,
                                                              _textListSize
                                                                      .length -
                                                                  1);
                                                      print(listSize);
                                                      print(textListSize);
                                                    });
                                                  },
                                                  child: Text('เพิ่ม')),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'สี',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            height: 40,
                                            width: double.infinity,
                                            child: listColor.length == 0 ||
                                                    textListColors == 'null'
                                                ? Text('ไม่มีข้อมูลสี')
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: listColor.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            index) {
                                                      return Card(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  '${listColor[index].split(':')[0]} : +${listColor[index].split(':')[1]}'),
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      listColor
                                                                          .removeAt(
                                                                              index);
                                                                      print(
                                                                          'listSing length : ${listColor.length}');
                                                                      String
                                                                          _textListColor =
                                                                          listColor
                                                                              .toString();
                                                                      textListColors =
                                                                          _textListColor.substring(
                                                                              1,
                                                                              _textListColor.length - 1);
                                                                      print(
                                                                          listColor);
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .highlight_remove,
                                                                    size: 15,
                                                                    color: Colors
                                                                        .red,
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                          ),
                                          Row(
                                            children: [
                                              Text('สี : '),
                                              Container(
                                                  decoration: boxDecorationGrey,
                                                  height: 30,
                                                  width: 70,
                                                  child: TextField(
                                                    controller: textColorName,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                  )),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text('ราคาบวกเพิ่ม : '),
                                              Container(
                                                  decoration: boxDecorationGrey,
                                                  height: 30,
                                                  width: 70,
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: textColorPrice,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                  )),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Container(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.teal),
                                                  onPressed: () {
                                                    String _textColorName =
                                                        textColorName.text
                                                            .toString();
                                                    int _textColorPrice =
                                                        int.parse(textColorPrice
                                                            .text);
                                                    setState(() {
                                                      listColor.add(
                                                          '${_textColorName}:${_textColorPrice}');
                                                      String _textListColors =
                                                          listColor.toString();
                                                      textListColors =
                                                          _textListColors.substring(
                                                              1,
                                                              _textListColors
                                                                      .length -
                                                                  1);
                                                      print(listColor);
                                                      print(textListColors);
                                                    });
                                                  },
                                                  child: Text('เพิ่ม')),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _showAddDetails = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.arrow_drop_up_outlined,
                                          color: Colors.teal,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "ระยะเวลาในการลงทะเบียน",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pickDealBegin(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                                Text("วันเริ่ม"),
                                Text("${_textDealBegin ?? 'เลือกวันที่'}"),
                              ],
                            ),
                            Icon(Icons.arrow_forward),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pickDealFinal(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                                Text("วันสิ้นสุด"),
                                Text("${_textDealFinal ?? 'เลือกวันที่'}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "ระยะเวลาในการใช้สิทธิ์ลดราคา",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pickDateBegin(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                                Text("วันเริ่ม"),
                                Text('${_textDateBegin ?? 'เลือกวันที่'}'),
                              ],
                            ),
                            Icon(Icons.arrow_forward),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pickDateFinal(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                                Text("วันสิ้นสุด"),
                                Text("${_textDateFinal ?? 'เลือกวันที่'}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.teal),
                      child: Text(
                        "แก้ไขสินค้า",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: updateItemData),
                ),
              ],
            ),
          ),
        ));
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
        _textDealBegin = "${date!.day}/${date.month}/${date.year}";
        dealBegin = "${date.month}/${date.day}/${date.year}";
        print(date);
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
        _textDealFinal = "${date!.day}/${date.month}/${date.year}";
        dealFinal = "${date.month}/${date.day}/${date.year}";
        print(date);
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
        _textDateBegin = "${date!.day}/${date.month}/${date.year}";
        dateBegin = "${date.month}/${date.day}/${date.year}";
        print(date);
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
        _textDateFinal = "${date!.day}/${date.month}/${date.year}";
        dateFinal = "${date.month}/${date.day}/${date.year}";
        print(date);
      });
    });
  }

  void _onDeleteItem(BuildContext context) async {
    print('Show Alert Dialog Delete Item !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ต้องการลบสินค้า ?'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ลบสินค้า'),
                          onTap: () {
                            Navigator.pop(context);
                            deleteItem();
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('ยกเลิก'),
                          onTap: () {
                            Navigator.of(context).pop();
                          })),
                ],
              ),
            ),
          );
        });
  }

  void _showAlertSelectImage(BuildContext context) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Choice'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('Gallery'),
                          onTap: () {
                            _onGallery();
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('Camera'),
                          onTap: () {
                            _onCamera();
                          })),
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
        _listImageShow!.insert(0, base64Encode(imageFile!.readAsBytesSync()));
        _listByteAddImage.insert(0, base64Encode(imageFile!.readAsBytesSync()));
        _listFileAddImage.insert(0, imageFile);
      });
      chekButton = true;
      print(chekButton);
      print("_listByteAddImage : ${_listByteAddImage}");
      print("_listFileAddImage : ${_listFileAddImage}");
      print('_listImageShow length : ${_listImageShow!.length}');
      Navigator.of(context).pop();
      return imageFile;
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
        _listImageShow!.insert(0, base64Encode(imageFile!.readAsBytesSync()));
        _listByteAddImage.insert(0, base64Encode(imageFile!.readAsBytesSync()));
        _listFileAddImage.insert(0, imageFile);
      });
      chekButton = true;
      print(chekButton);
      print("_listByteAddImage : ${_listByteAddImage}");
      print("_listFileAddImage : ${_listFileAddImage}");
      print('_listImageShow length : ${_listImageShow!.length}');
      Navigator.of(context).pop();
      return imageFile;
    } else {
      return null;
    }
  }

  _onDeleteShowImageList(index) {
    print(index);
    if (_listFileAddImage.length == 0) {
      print("_listFileAddImage.length == 0");
      if (index >= _listFileAddImage.length) {
        print('รูปเดิม');
        setState(() {
          _listDeleteImage.add(_resIdData![index]);
          _resIdData!.removeAt(index);
          _listImageShow!.removeAt(index);
        });
      }
    } else if (_listFileAddImage.length != 0) {
      print("_listFileAddImage.length != 0");
      if (index <= _listFileAddImage.length - 1) {
        print('รูปใหม่');
        setState(() {
          _listFileAddImage.removeAt(index);
          _listImageShow!.removeAt(index);
        });
      } else if (index >= _listFileAddImage.length) {
        print('รูปเดิม');
        setState(() {
          _listDeleteImage.add(_resIdData![index - _listFileAddImage.length]);
          _resIdData!.removeAt(index - _listFileAddImage.length);
          _listImageShow!.removeAt(index);
        });
      }
    }
    print('list delete image : ${_listDeleteImage}');
    print('list add image : ${_listFileAddImage}');
    print('list image show length : ${_listImageShow!.length}');
  }

  Future<List> getImage(_itemId) async {
    await http.get(
        Uri.parse('${urlGetImageByItemId.toString()}${_itemId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      // print(res.body);
      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _statusData = jsonData['status'];
      var _dataImage = jsonData['dataImages'];
      if (_statusData == 1) {
        _resImageData = _dataImage;
        _resIdData = jsonData['dataId'];
        //print("jsonData : ${_resData.toString()}");
      }
    });
    return _resImageData!;
  }

  void updateItemData() {
    if ((_listDeleteImage.length - _listImageShow!.length) ==
        _listDeleteImage.length) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNoHaveImage);
    } else {
      saveToDB();
    }
  }

  void saveToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnSave);
    Map params = Map();
    params['itemId'] = itemData.itemID.toString();
    params['marketId'] = itemData.marketID.toString();
    params['nameItems'] = nameItem.toString();
    params['groupItems'] = itemData.groupItems.toString();
    params['price'] = price.toString();
    params['priceSell'] = priceSell.toString();
    params['count'] = count.toString();
    params['size'] = textListSize.toString();
    params['colors'] = textListColors.toString();
    params['countRequest'] = countRequest.toString();
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
      setState(() {
        if (_resStatus == 1) {
          _checkListImageAdd();
          _checkListImageDelete();
          ScaffoldMessenger.of(context).showSnackBar(snackBarOnSaveSuccess);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarSaveFail);
        }
      });
    });
  }

  void deleteItem() async {
    Map params = Map();
    params['itemId'] = itemData.itemID.toString();

    var resDeleteImage = await http.post(Uri.parse(urlDeleteImage),
        body: params,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        });
    print("RespondDeleteImage : ${resDeleteImage.body}");

    var resDeleteItem = await http.get(
        Uri.parse("${urlDeleteItem.toString()}${itemData.itemID}"),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        });
    print("RespondDeleteItem : ${resDeleteItem.body}");

    Navigator.of(context).pop();
  }

  void _checkListImageAdd() {
    if (_listFileAddImage.length != 0) {
      print('list');
      saveImage(itemData.itemID);
    } else {
      return print('No Have Image add');
    }
  }

  void saveImage(_itemId) async {
    print("ItemID : ${_itemId.toString()}");

    _listFileAddImage.forEach((element) async {
      print("save image Item ID : ${_itemId.toString()}");
      print("Update image File : ${element}");

      var request = http.MultipartRequest('POST', Uri.parse(urlSaveImage));

      var _multipart =
          await http.MultipartFile.fromPath('picture', element.path);
      request.files.add(_multipart);

      request.headers.addAll(
          {HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'});
      request.fields['itemId'] = _itemId.toString();
      request.fields['marketId'] = marketID.toString();

      await http.Response.fromStream(await request.send()).then((res) {
        print(res.body);
      });
    });
  }

  void _checkListImageDelete() {
    if (_listDeleteImage.length != 0) {
      print('listDeleteImage : ${_listDeleteImage}');
      _listDeleteImage.forEach((element) {
        http.get(Uri.parse("${urlDeleteImageByImageId}${element}"), headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((value) {
          print(value.body);
        });
      });
    } else {
      return print('No Have Image delete');
    }
  }
}
