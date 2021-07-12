import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/models/order.dart';
import 'order_card.dart';

class OrdersPageView extends ConsumerWidget {
  final List<Order> orders;

  OrdersPageView(this.orders);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return ListView(
      padding: EdgeInsets.all(4),
      children: orders
          .map(
            (e) => OrderCard(
              order: e,
              key: Key(e.id),
            ),
          )
          .toList(),
    );
  }
}
