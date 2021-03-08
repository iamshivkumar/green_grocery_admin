import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/models/cartProduct.dart';
import 'package:green_grocery_admin/core/streams/order_stream_provider.dart';
import 'package:green_grocery_admin/core/view_models/orders_view_model/orders_view_model_provider.dart';
import 'widgets/delivery_boy_selector.dart';
import 'widgets/two_text_row.dart';

class OrderDetailsPage extends ConsumerWidget {
  final String id;
  const OrderDetailsPage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var model = context.read(ordersViewModelProvider);
    var orderStream = watch(orderStreamProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: orderStream.when(
        data: (order) {
          // ignore: unused_element
          Widget widget() {
            switch (order.status) {
              case "Pending":
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      model.setAsPacked(id);
                    },
                    child: Text("SET AS PACKED"),
                  ),
                );
              case "Packed":
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
              case "Out For Delivery":
                return TwoTextRow(
                    text1: "Delivery Boy", text2: order.deliveryBoy);
              default:
                return TwoTextRow(
                    text1: "Delivery Boy", text2: order.deliveryBoy);
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
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Column(
                      children: order.products.map((e) {
                        var product = CartProduct.fromJson(e);
                        return ListTile(
                          title: Text(product.name),
                          leading: SizedBox(
                            height: 56,
                            width: 56,
                            child: Image.network(product.image),
                          ),
                          subtitle: Text(
                            product.qt.toString() +
                                " Items x ₹" +
                                product.price.toString(),
                          ),
                          trailing: Text(
                            "₹" + (product.qt * product.price).toString(),
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
                        text2: '₹' + order.price.toString()),
                    TwoTextRow(
                        text1: "Delivery",
                        text2: '₹' + order.delivery.toString()),
                    TwoTextRow(
                        text1: 'Service Tax',
                        text2: '₹' + order.tax.toString()),
                    TwoTextRow(
                        text1: "Wallet Amount",
                        text2: '₹' + order.walletAmount.toString()),
                    TwoTextRow(
                        text1: 'Total Price',
                        text2: '₹' + order.totalPrice.toString())
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
                    TwoTextRow(text1: "Status", text2: order.status),
                    widget(),
                    Divider(),
                    TwoTextRow(text1: "Delivery Date", text2: order.date),
                    TwoTextRow(text1: 'Delivery By', text2: order.deliveryBy),
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
                          key: Key(order.customerAddress),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(order.geoPoint.latitude,
                                order.geoPoint.longitude),
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("1"),
                              position: LatLng(order.geoPoint.latitude,
                                  order.geoPoint.longitude),
                            ),
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(order.customerAddress),
                    ),
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
                    TwoTextRow(text1: "Status", text2: order.paymentStatus),
                    TwoTextRow(
                        text1: "Payment Method", text2: order.paymentMethod),
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
  WhiteCard({this.child});

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
