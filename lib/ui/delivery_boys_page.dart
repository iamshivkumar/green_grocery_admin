import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/streams/delivery_boys_list_provider.dart';
import 'package:green_grocery_admin/core/view_models/delivery_boys_view_model/delivery_boys_view_model.dart';

class DeliveryBoysPage extends ConsumerWidget {
  final DeliveryBoyViewModel _model = DeliveryBoyViewModel();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var deliveryBoysStream = watch(deliveryBoysListProvder);
    void showEditor() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              (_model.deliveryBoy != null ? "Edit" : "Add") + " Delivery Boy"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onSaved: _model.setName,
                  initialValue: _model.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) =>
                      value.isEmpty ? "Enter name of delivery boy" : null,
                ),
                TextFormField(
                  onSaved: _model.setMobile,
                  initialValue: _model.mobile,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value.isEmpty
                      ? "Enter Phone Number of delivery boy"
                      : null,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixText: "+91",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Delivery Boy can login with this phone number.",
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("CANCEL"),
            ),
            MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _model.addEditDeliveryBoy();
                  Navigator.pop(context);
                }
              },
              child: Text(_model.deliveryBoy != null ? "SAVE" : "ADD"),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Boys"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showEditor();
        },
        child: Icon(Icons.add),
      ),
      body: deliveryBoysStream.when(
        data: (deliveryBoys) => ListView(
          children: deliveryBoys
              .map(
                (e) => Material(
                  color: Colors.white,
                  child: ListTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.call), onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _model.initForEdit(e);
                              showEditor();
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _model.deleteDeliveryBoy(e.id);
                            }),
                      ],
                    ),
                    title: Text(e.name),
                    subtitle: Text("+91" + e.mobile),
                  ),
                ),
              )
              .toList(),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => SizedBox(),
      ),
    );
  }
}
