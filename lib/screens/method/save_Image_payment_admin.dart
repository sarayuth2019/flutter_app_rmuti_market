import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/config/config.dart';
import 'package:http/http.dart' as http;

void saveImagePaymentAdmin(
    context, token, int payId, File imageFile) async {
  print("payId : ${payId.toString()}");
  print("save image pay Id : ${payId.toString()}");
  print("Update image File : ${imageFile.toString()}");

  final String urlSaveImagePay = '${Config.API_URL}/ImagePay/save';
  var request = http.MultipartRequest('POST', Uri.parse(urlSaveImagePay));
  request.headers
      .addAll({HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'});

  var _multipart = await http.MultipartFile.fromPath('picture', imageFile.path);

  request.files.add(_multipart);
  request.fields['payId'] = payId.toString();

  await http.Response.fromStream(await request.send()).then((res) {
    print(res.body);
    var resData = jsonDecode(res.body);
    var statusRes = resData['status'];
    if (statusRes == 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('บันทึก สำเร็จ รอการตรวจสอบการชำระเงินจากร้านค้า')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('บันทึกภาพ ชำระเงินผิดพลาด !')));
    }
  });
}
