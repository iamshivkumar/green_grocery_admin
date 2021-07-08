import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/enums/order_status.dart';
import '../../core/service/areas_polygons_provider.dart';
\import 'package:green_grocery_admin/core/streams/orders_list_stream_provider.dart';
import 'package:green_grocery_admin/core/view_models/map_view_model/map_view_model_provider.dart';
import 'package:green_grocery_admin/core/view_models/orders_view_model/orders_view_model_provider.dart';
import 'package:green_grocery_admin/ui/widgets/order_card.dart';

class OrdersMapView extends ConsumerWidget {
  final OrderStatus status;
  OrdersMapView({required this.status});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var mapModel = watch(mapViewModelProvider);
    var areasPolygonsFuture = watch(areasPolygonsProvider);
    var ordersListStream = watch(ordersListStreamProvider(status));
    var model = context.read(ordersViewModelProvider);
    return Stack(
      children: [
        GoogleMap(
          onTap: (argument) => mapModel.setOrder(null),
          compassEnabled: true,
          markers: ordersListStream.when(
            data: (orders) => orders
                .where((element) => model.deliveryDay != null
                    ? element.date == model.deliveryDay
                    : true)
                .where((element) => model.deliveryBy != null
                    ? element.deliveryBy == model.deliveryBy
                    : true)
                .map(
                  (e) => Marker(
                    infoWindow: InfoWindow(
                        title: e.date == _date.activeDate(0)
                            ? "Today"
                            : e.date == _date.activeDate(1)
                                ? "Tommorow"
                                : e.date,
                        snippet: e.deliveryBy),
                    markerId: MarkerId(e.id),
                    onTap: () => mapModel.setOrder(e),
                    position: LatLng(e.geoPoint.latitude, e.geoPoint.longitude),
                  ),
                )
                .toSet(),
            loading: () => {},
            error: (error, stackTrace) => {},
          ),
          onCameraMove: mapModel.onCameraMove,
          mapType: mapModel.mapType,
          polygons: areasPolygonsFuture.when(
            data: (areasPolygons) => areasPolygons,
            loading: () => {},
            error: (error, stackTrace) => {},
          ),
          initialCameraPosition: mapModel.position,
          onMapCreated: (controller) => mapModel.setController(controller),
        ),
        mapModel.order != null
            ? Positioned(
              bottom: 0,
              left: 0,
              right: 120,
                child: SmallOrderCard(
                  order: mapModel.order,
                ),
              )
            : SizedBox()
      ],
    );
  }
}
