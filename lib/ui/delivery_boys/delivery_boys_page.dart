import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/streams/delivery_boys_list_provider.dart';
import '../../core/view_models/delivery_boys_view_model/delivery_boys_view_model.dart';

class DeliveryBoysPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final _model = context.read(deliveryBoyViewModelProvider);
    final deliveryBoysStream = watch(deliveryBoysListProvder);

    Future<void> showEditor() async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text((_model.deliveryBoy.id != null ? "Edit" : "Add") +
              " Delivery Boy"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onSaved: (v) => _model.deliveryBoy.name = v!,
                  initialValue: _model.deliveryBoy.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter name of delivery boy" : null,
                ),
                TextFormField(
                  onSaved: (v) => _model.deliveryBoy.mobile = v!,
                  initialValue: _model.deliveryBoy.mobile,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _model.addEditDeliveryBoy();
                  Navigator.pop(context);
                }
              },
              child: Text(_model.deliveryBoy.id != null ? "SAVE" : "ADD"),
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
        onPressed: () async{
         await showEditor();
         _model.clear();
        },
        child: Icon(Icons.add),
      ),
      body: deliveryBoysStream.when(
        data: (deliveryBoys) => ListView(
          children: deliveryBoys
              .map(
                (e) => Dismissible(
                  direction: DismissDirection.startToEnd,
                  onDismissed: (d) => _model.deleteDeliveryBoy(e.id!),
                  background: Material(
                    color: theme.primaryColorDark,
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Center(
                            child: Icon(
                              Icons.delete,
                              color: theme.cardColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  key: ValueKey(e.id),
                  child: Material(
                    color: Colors.white,
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //TODO: call
                          IconButton(icon: Icon(Icons.call), onPressed: () {}),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              _model.deliveryBoy = e;
                              await showEditor();
                              _model.clear();
                            },
                          ),
                        ],
                      ),
                      title: Text(e.name),
                      subtitle: Text("+91" + e.mobile),
                    ),
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
