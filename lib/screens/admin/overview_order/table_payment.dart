import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_market/screens/method/list_payment_all.dart';

class TablePayment extends StatelessWidget {
   TablePayment(this.listPayment);

   final List<Payment>listPayment;

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: ListView.builder(
         //physics: NeverScrollableScrollPhysics(),
         scrollDirection: Axis.vertical,
         shrinkWrap: true,
         itemCount: listPayment.length,
         itemBuilder: (BuildContext context, int index) {
           return Padding(
             padding:
             const EdgeInsets.only(left: 8.0, right: 8.0),
             child: Table(
               children: [
                 TableRow(children: [
                   Text('${listPayment[index].payId}'),
                   Text('${listPayment[index].amount}'),
                   Text('${listPayment[index].status}'),
                 ])
               ],
             ),
           );
         }),
   );
  }
}


