import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/streams/settings_stream_provider.dart';

class SettingsPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var settingsStream = watch(settingsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: settingsStream.when(
        data: (settings) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: Material(
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) =>
                            value.isEmpty ? "Enter Delivery Charge" : null,
                        keyboardType: TextInputType.number,
                        initialValue: settings.deliveryCharge.toString(),
                        onSaved: settings.onChangedDeliveryCharge,
                        decoration:
                            InputDecoration(labelText: "Delivery Charge"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) => value.isEmpty
                            ? "Enter Service Tax Percentage"
                            : null,
                        initialValue: settings.serviceTaxPercentage.toString(),
                        onSaved: settings.onChangedServiceTaxPercentage,
                        decoration: InputDecoration(
                            labelText: "Service Tax Percentage"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        child: Text("SAVE"),
                        onPressed: () {
                          settings.save();
                          Navigator.pop(context);
                        },
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => SizedBox(),
      ),
    );
  }
}
