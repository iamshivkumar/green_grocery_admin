import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/loading.dart';
import '../providers/orders_provider.dart';
import '../providers/orders_view_model_provider.dart';
import 'order_card.dart';

class OrdersPageView extends ConsumerWidget {
  final String status;

  OrdersPageView(this.status);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ordersStream = watch(ordersProvider(status));
    final model = context.read(ordersViewModelProvider);

    return ordersStream.when(
      data: (orders) => ListView(
        padding: EdgeInsets.all(4),
        children: orders
            .where(
              (element) =>model.selectedDate!=null? element.deliveryDate == model.selectedDate:true,
            ).where(
              (element) =>model.deliveyBy!=null? element.deliveryBy == model.deliveyBy:true,
            )
            .map(
              (e) => OrderCard(order: e),
            )
            .toList(),
      ),
      loading: () => Loading(),
      error: (e, s) => Text(e.toString()),
    );
  }
}
