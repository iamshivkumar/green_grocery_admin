import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/view_models/auth_view_model/auth_view_model_provider.dart';
import '../../delivery_boys_page.dart';
import '../../login_page.dart';
import '../../orders_page.dart';
import '../../refund_requests_page.dart';
import '../../settings_page.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Material(
        color: Theme.of(context).accentColor,
        child: Theme(
          data: ThemeData.dark()
              .copyWith()
              .copyWith(textTheme: theme.primaryTextTheme),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Orders"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrdersPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text("Delivery Boys"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DeliveryBoysPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text("Refund Requests"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RefundRequestsPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text("Settings"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SettingsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  context.read(authViewModelProvider).logout();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(),
                    ),
                  );
                },
                title: Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
