import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_grocery_admin/utils/utils.dart';

import '../../../core/models/order.dart';
import '../../order/order_details_page.dart';
import '../../widgets/two_text_row.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                key: Key(order.id),
                id: order.id,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TwoTextRow(
                  text1: "Delivery Date",
                  text2: Utils.formatedDate(order.deliveryDate),
                ),
                TwoTextRow(
                  text1: "Delivery By",
                  text2: describeEnum(order.deliveryBy),
                ),
                Divider(
                  height: 0.5,
                ),
                TwoTextRow(
                  text1: "Ordered at",
                  text2: Utils.formatedDate(order.createdOn),
                ),
                TwoTextRow(
                  text1: "Items",
                  text2: "${order.items} Items purchased",
                ),
                TwoTextRow(
                  text1: "Price",
                  text2: "₹" + order.total.toInt().toString(),
                ),
                TwoTextRow(
                  text1: "Payment (${order.paymentMethod})",
                  text2: order.paid ? "Paid" : "Not Paid",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SmallOrderCard extends StatelessWidget {
  final Order order;
  const SmallOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                key: Key(order.id),
                id: order.id,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TwoTextRow(
                  text1: "Ordered at",
                  text2: Utils.formatedDate(order.createdOn),
                ),
                TwoTextRow(
                  text1: "Items",
                  text2: "${order.items} Items purchased",
                ),
                TwoTextRow(
                  text1: "Price",
                  text2: "₹" + order.total.toString().toString(),
                ),
                TwoTextRow(
                  text1: "Payment",
                  text2: order.paid ? "Paid" : "Not Paid",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
