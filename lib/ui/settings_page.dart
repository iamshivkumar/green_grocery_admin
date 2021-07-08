import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/streams/settings_stream_provider.dart';

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
                        validator: (v) =>
                            v!.isEmpty ? "Enter Delivery Charge" : null,
                        keyboardType: TextInputType.number,
                        initialValue: settings.deliveryCharge.toString(),
                        onSaved: (v) =>
                            settings.deliveryCharge = double.parse(v!),
                        decoration: InputDecoration(
                          labelText: "Delivery Charge",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v!.isEmpty ? "Enter Service Tax Percentage" : null,
                        initialValue: settings.serviceTaxPercentage.toString(),
                        onSaved: (v) =>
                            settings.serviceTaxPercentage = double.parse(v!),
                        decoration: InputDecoration(
                          labelText: "Service Tax Percentage",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        child: Text("SAVE"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            settings.save();
                            Navigator.pop(context);
                          }
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
