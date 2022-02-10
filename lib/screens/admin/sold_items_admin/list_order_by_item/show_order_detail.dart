import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/method/getDetailOrder.dart';

void showOrderDetail(
    BuildContext context, token, List<Detail> listOrderDetail) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              'รายละเอียด Order Id : ${listOrderDetail[0].orderId.toString()}',
              style: TextStyle(fontSize: 17),
            ),
            content: Container(
              height: 31 * double.parse(listOrderDetail.length.toString()),
              width: 600,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listOrderDetail.length,
                  itemBuilder: (BuildContext context, index) {
                    return Row(
                      children: [
                        Text(
                            '${listOrderDetail[index].nameItem.split(':')[1]} x ${listOrderDetail[index].number}'),
                        listOrderDetail[index].size == 'null'
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0, right: 4.0),
                                child: Text(
                                    'ขนาด : ${listOrderDetail[index].size.split(':')[0]}'),
                              ),
                        listOrderDetail[index].color == 'null'
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0, right: 4.0),
                                child: Text(
                                    'สี : ${listOrderDetail[index].color.split(':')[0]}'),
                              ),
                      ],
                    );
                  }),
            ));
      });
}
