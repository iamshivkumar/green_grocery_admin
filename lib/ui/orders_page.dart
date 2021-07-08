import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/enums/delivery_by.dart';
import '../core/enums/order_status.dart';
import '../core/view_models/orders_view_model/orders_view_model_provider.dart';
import '../utils/utils.dart';
import 'widgets/orders_card_view.dart';
import 'widgets/orders_map_view.dart';

class OrdersPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _controller =
        useTabController(initialLength: OrderStatus.values.length);
    return Consumer(
      builder: (context, watch, child) {
        var model = watch(ordersViewModelProvider);
        return Scaffold(
          appBar: AppBar(
            actions: [
              Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 32,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 4),
                      child: Icon(
                        Icons.location_pin,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Switch(
                value: model.mapMode,
                onChanged: model.setMapMode,
              ),
            ],
            title: Text('My Orders'),
            bottom: TabBar(
              onTap: (value) {
                if (model.mapMode) {}
              },
              controller: _controller,
              isScrollable: true,
              tabs: OrderStatus.values
                  .map(
                    (e) => Tab(
                      text: describeEnum(e),
                    ),
                  )
                  .toList(),
            ),
          ),
          body: Stack(
            children: [
              model.mapMode
                  ? OrdersMapView(
                      status: OrderStatus.values[_controller.index],
                    )
                  : TabBarView(
                      controller: _controller,
                      children: OrderStatus.values
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
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                "Filter through delivery day and delivery by:",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: Utils.deliveryDates.map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: ChoiceChip(
                                      selected: model.deliveryDay ==
                                          _date.activeDate(0),
                                      onSelected: (value) =>
                                          model.setDeliveryDay(value
                                              ? _date.activeDate(0)
                                              : null),
                                      label: Text(Utils.weekday(e),),
                                    ),
                                  ),).toList()
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: DeliveyBy.values
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 0, 4, 4),
                                          child: ChoiceChip(
                                            selected: model.deliveyBy == e,
                                            onSelected: (value) => model
                                                .deliveyBy = value ? e : null,
                                            label: Text(
                                              describeEnum(e),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
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
        );
      },
    );
  }
}
