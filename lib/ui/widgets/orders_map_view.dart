import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_grocery_admin/core/models/order.dart';
import 'package:green_grocery_admin/utils/utils.dart';
import '../../core/service/areas_polygons_provider.dart';
import 'package:green_grocery_admin/core/view_models/map_view_model/map_view_model_provider.dart';
import 'package:green_grocery_admin/ui/widgets/order_card.dart';

class OrdersMapView extends ConsumerWidget {
  final List<Order> orders;

  OrdersMapView(this.orders);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var mapModel = watch(mapViewModelProvider);
    var areasPolygonsFuture = watch(areasPolygonsProvider);
    return Stack(
      children: [
        GoogleMap(
          onTap: (argument) => mapModel.order = null,
          compassEnabled: true,
          markers: orders
                .map(
                  (e) => Marker(
                    infoWindow: InfoWindow(
                        title: Utils.weekday(e.deliveryDate),
                        snippet: describeEnum( e.deliveryBy),),
                    markerId: MarkerId(e.id),
                    onTap: () => mapModel.order = e,
                    position: LatLng(e.location.latitude, e.location.longitude),
                  ),
                )
                .toSet(),
        
          
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
