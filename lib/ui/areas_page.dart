import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_grocery_admin/core/view_models/areas_view_model/areas_view_model_provider.dart';
import 'package:green_grocery_admin/ui/add_area_page.dart';

class AreasPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var addressModel = watch(addressViewModelProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAreaPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  compassEnabled: true,
                  onCameraMove: addressModel.onCameraMove,
                  mapType: addressModel.mapType,
                  initialCameraPosition: addressModel.position,
                  polygons: addressModel.areas
                      .map((e) => Polygon(
                          geodesic: true,
                          polygonId: PolygonId(e.name),
                          points: e.points
                              .map((e) => LatLng(e["lat"], e["long"]))
                              .toList(),
                          strokeWidth: 2,
                          fillColor: Colors.red.withOpacity(0.1)))
                      .toSet(),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: RawMaterialButton(
                    elevation: 2,
                    child: Icon(
                      Icons.layers_outlined,
                    ),
                    onPressed: addressModel.toggleMapType,
                    constraints: BoxConstraints.tightFor(
                      width: 40,
                      height: 40,
                    ),
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              children: addressModel.areas
                  .map(
                    (e) => ListTile(
                      title: Text(e.name),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
