import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_grocery_admin/core/view_models/areas_view_model/areas_view_model_provider.dart';

class AddAreaPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var addressModel = watch(addressViewModelProvider);
    return WillPopScope(
      onWillPop: () async {
        addressModel.limitedDispose();
        return true;
      },
      child: Scaffold(
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
                    onMapCreated: (controller) =>
                        addressModel.setController(controller),
                    polygons: addressModel.polygons,
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
                  Center(
                    child: Icon(
                      Icons.gps_not_fixed,
                      color: addressModel.mapType == MapType.normal
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.add,
                      size: 8,
                      color: addressModel.mapType == MapType.normal
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 104 + 8.0,
                    child: RawMaterialButton(
                      elevation: 2,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.white,
                      ),
                      onPressed: addressModel.addCoordinate,
                      constraints: BoxConstraints.tightFor(
                        width: 56.0,
                        height: 56.0,
                      ),
                      shape: CircleBorder(),
                      fillColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    addressModel.limitedDispose();
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                MaterialButton(
                  onPressed: addressModel.isPointsAdded
                      ? () {
                          addressModel.save();
                          Navigator.pop(context);
                        }
                      : null,
                  color: Theme.of(context).primaryColor,
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
