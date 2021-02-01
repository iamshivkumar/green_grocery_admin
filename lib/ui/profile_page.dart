import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/view_models/auth_view_model/auth_view_model_provider.dart';


class ProfilePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var authModel = context.read(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Material(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onSaved: (value) => authModel.user
                                  .updateProfile(displayName: value),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline),
                                  hintText: "Your Name"),
                              initialValue: authModel.user.displayName,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: false,
                              initialValue: authModel.user.phoneNumber,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_outlined)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              colorBrightness: Brightness.dark,
                              onPressed: () {
                                if (_formKey.currentState.validate())
                                  _formKey.currentState.save();
                                Navigator.pop(context);
                              },
                              color: Theme.of(context).primaryColor,
                              child: Text('Save'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
