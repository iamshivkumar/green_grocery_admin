import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:green_grocery_admin/core/service/date.dart';
import 'package:green_grocery_admin/core/streams/orders_list_stream_provider.dart';
import 'package:green_grocery_admin/core/view_models/orders_view_model/orders_view_model_provider.dart';
import 'widgets/order_card.dart';

class OrdersPage extends ConsumerWidget {
  final List<String> tabTexts = [
    "Pending",
    "Packed",
    "Out For Delivery",
    "Delivered",
    "Cancelled"
  ];
  final List<String> deliveryByRanges = [
    "9:00 AM - 10:30 AM",
    '10:00 AM - 11:00 AM',
    '12:00 PM - 1:00 PM',
    '2:00 PM - 4:00 PM'
  ];
  final Date _date = Date();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var model = watch(ordersViewModelProvider);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabTexts
                .map(
                  (e) => Tab(
                    text: e,
                  ),
                )
                .toList(),
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: tabTexts
                  .map(
                    (e) => OrdersPageView(
                      status: e,
                    ),
                  )
                  .toList(),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("Delivery Day"),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ChoiceChip(
                                      onSelected: (value) =>
                                          model.setDeliveryDay(null),
                                      selected: model.deliveryDay == null,
                                      label: Text("All"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ChoiceChip(
                                      selected: model.deliveryDay ==
                                          _date.activeDate(0),
                                      onSelected: (value) => model
                                          .setDeliveryDay(_date.activeDate(0)),
                                      label: Text("Today"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ChoiceChip(
                                      selected: model.deliveryDay ==
                                          _date.activeDate(1),
                                      onSelected: (value) => model
                                          .setDeliveryDay(_date.activeDate(1)),
                                      label: Text("Tommorow"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ChoiceChip(
                                      selected: model.deliveryDay ==
                                          _date.activeDate(2),
                                      onSelected: (value) => model
                                          .setDeliveryDay(_date.activeDate(2)),
                                      label: Text(_date.activeDay(2)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("Delivery By"),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ChoiceChip(
                                      selected: model.deliveryBy == null,
                                      onSelected: (value) =>
                                          model.setDeliveryBy(null),
                                      label: Text("All"),
                                    ),
                                  ),
                                  Row(
                                    children: deliveryByRanges
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ChoiceChip(
                                              selected: model.deliveryBy == e,
                                              onSelected: (value) =>
                                                  model.setDeliveryBy(e),
                                              label: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersPageView extends ConsumerWidget {
  final String status;
  OrdersPageView({this.status});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var ordersListStream = watch(ordersListStreamProvider(status));
    var model = context.read(ordersViewModelProvider);
    return ordersListStream.when(
      data: (ordersList) => ListView(
        padding: EdgeInsets.all(4),
        children: <Widget>[
              SizedBox(
                height: 180,
              )
            ] +
            ordersList
                .where((element) => model.deliveryDay != null
                    ? element.date == model.deliveryDay
                    : true)
                .where((element) => model.deliveryBy != null
                    ? element.deliveryBy == model.deliveryBy
                    : true)
                .map(
                  (e) => OrderCard(
                    order: e,
                    key: Key(e.id),
                  ),
                )
                .toList(),
      ),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Text(
        error.toString(),
      ),
    );
  }
}
