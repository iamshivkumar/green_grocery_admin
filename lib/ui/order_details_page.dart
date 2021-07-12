import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_grocery_admin/core/enums/order_status.dart';
import 'package:green_grocery_admin/core/service/place_mark_provider.dart';
import 'package:green_grocery_admin/utils/utils.dart';

import '../core/streams/order_stream_provider.dart';
import 'widgets/delivery_boy_selector.dart';
import 'widgets/two_text_row.dart';

class OrderDetailsPage extends ConsumerWidget {
  final String id;
  const OrderDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final orderStream = watch(orderStreamProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: orderStream.when(
        data: (order) {
          final placeAsync = watch(placeProvider(order.location));

          Widget widget() {
            switch (order.status) {
              case OrderStatus.Ordered:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      // model.setAsPacked(id);
                    },
                    child: Text("SET AS PACKED"),
                  ),
                );
              case OrderStatus.Packed:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => DeliveryBoySelector(
                          id: order.id,
                        ),
                      );
                    },
                    child: Text("SET AS OUT FOR DELIVERY"),
                  ),
                );
              case OrderStatus.OutForDelivery:
                return TwoTextRow(
                    text1: "Delivery Boy", text2: order.deliveryBoyMobile!);
              default:
                return SizedBox();
            }
          }

          return ListView(
            padding: EdgeInsets.all(4),
            children: [
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Products',
                        style: TextStyle(
                            fontSize: 18,
                            color: theme.primaryColor),
                      ),
                    ),
                    Column(
                      children: order.products.map((e) {
                        return ListTile(
                          title: Text(e.name),
                          leading: SizedBox(
                            height: 56,
                            width: 56,
                            child: Image.network(e.image),
                          ),
                          subtitle: Text(
                            e.qt.toString() + " Items x ₹" + e.price.toString(),
                          ),
                          trailing: Text(
                            "₹" + (e.qt * e.price).toString(),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Order Summary',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    TwoTextRow(
                      text1: "Items (6)",
                      text2: '₹' + order.price.toString(),
                    ),
                    TwoTextRow(
                      text1: "Delivery",
                      text2: '₹' + order.deliveryCharge.toString(),
                    ),
                    TwoTextRow(
                      text1: "Wallet Amount",
                      text2: '₹' + order.walletAmount.toString(),
                    ),
                    TwoTextRow(
                      text1: 'Total Price',
                      text2: '₹' + order.total.toInt().toString(),
                    )
                  ],
                ),
              ),
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Delivery Details',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    TwoTextRow(
                        text1: "Status", text2: describeEnum(order.status)),
                    widget(),
                    Divider(),
                    TwoTextRow(
                      text1: "Delivery Date",
                      text2: Utils.formatedDate(order.deliveryDate),
                    ),
                    TwoTextRow(
                      text1: 'Delivery By',
                      text2: describeEnum(order.deliveryBy),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Delivery Address'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 2,
                        child: GoogleMap(
                          liteModeEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(order.location.latitude,
                                order.location.longitude),
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("1"),
                              position: LatLng(order.location.latitude,
                                  order.location.longitude),
                            ),
                          },
                        ),
                      ),
                    ),
                    placeAsync.data != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(placeAsync.data!.value),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Payment',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    TwoTextRow(
                      text1: "Status",
                      text2: order.paid ? "Paid" : "Not Paid",
                    ),
                    TwoTextRow(
                      text1: "Payment Method",
                      text2: order.paymentMethod,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => SizedBox(),
      ),
    );
  }
}

class WhiteCard extends StatelessWidget {
  final Widget child;
  WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        child: Padding(padding: const EdgeInsets.all(12.0), child: child),
      ),
    );
  }
}
