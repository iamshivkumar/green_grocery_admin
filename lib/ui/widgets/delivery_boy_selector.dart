import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/ui/order/providers/order_view_model_provider.dart';
import 'package:green_grocery_admin/ui/orders/providers/orders_view_model_provider.dart';
import 'package:green_grocery_admin/ui/widgets/custom_radio_listtile.dart';

import '../../core/streams/delivery_boys_list_provider.dart';
class DeliveryBoySelector extends ConsumerWidget {
  const DeliveryBoySelector({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var deliveryBoysStream = watch(deliveryBoysListProvder);
    var model = watch(orderViewModelProvider(id));
    return Container(
      child: Column(
        children: [
          Material(
            color: Colors.white,
            child: ListTile(
              title: Text("Select Delivery Boy"),
            ),
          ),
          Expanded(
            child: deliveryBoysStream.when(
              data: (deliveryBoys) => Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView(
                  children: deliveryBoys
                      .map(
                        (e) => CustomRadioListTile(
                          value: e.mobile == model.deliveryBoyMobile,
                          onTap: () => model.deliveryBoyMobile = e.mobile,
                          title: Text(e.name),
                        ),
                      )
                      .toList(),
                ),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => SizedBox(),
            ),
          ),
          Material(
            color: Colors.white,
            child: ButtonBar(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                MaterialButton(
                  onPressed: model.deliveryBoyMobile != null
                      ? () {
                          model.setAsOutForDelivery(id: id);
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text("DONE"),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}