import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_grocery_admin/ui/orders/providers/map_view_model_provider.dart';
import 'package:green_grocery_admin/ui/orders/providers/orders_provider.dart';
import 'package:green_grocery_admin/utils/utils.dart';
import '../../product/providers/areas_polygons_provider.dart';
import 'package:green_grocery_admin/ui/orders/widgets/order_card.dart';

class OrdersMapView extends ConsumerWidget {
  final String status;

  OrdersMapView(this.status);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final mapModel = watch(mapViewModelProvider);
    final areasPolygonsFuture = watch(areasPolygonsProvider);
    final ordersStream = watch(ordersProvider(status));
    return Stack(
      children: [
        GoogleMap(
          onTap: (argument) => mapModel.order = null,
          compassEnabled: true,
          markers: ordersStream.when(
            data: (orders) => orders
                .map(
                  (e) => Marker(
                    infoWindow: InfoWindow(
                      title: Utils.weekday(e.deliveryDate),
                      snippet: describeEnum(e.deliveryBy),
                    ),
                    markerId: MarkerId(e.id),
                    onTap: () => mapModel.order = e,
                    position: LatLng(e.location.latitude, e.location.longitude),
                  ),
                )
                .toSet(),
            loading: () => {},
            error: (e, s) => {},
          ),
          mapType: mapModel.mapType,
          polygons: areasPolygonsFuture.when(
            data: (areasPolygons) => areasPolygons,
            loading: () => {},
            error: (error, stackTrace) => {},
          ),
          initialCameraPosition: mapModel.position,
        ),
        mapModel.order != null
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 120,
                child: SmallOrderCard(
                  order: mapModel.order!,
                ),
              )
            : SizedBox()
      ],
    );
  }
}
