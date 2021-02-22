import 'package:flutter/material.dart';
import 'package:green_grocery_admin/ui/delivery_boys_page.dart';
import 'package:green_grocery_admin/ui/orders_page.dart';
import 'package:green_grocery_admin/ui/refund_requests_page.dart';
import 'package:green_grocery_admin/ui/settings_page.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).accentColor,
        child: Theme(
          data: ThemeData.dark(),
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
    );
  }
}
