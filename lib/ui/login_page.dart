import 'package:flutter/material.dart';
import 'package:green_grocery_admin/ui/home_page.dart';
import 'package:green_grocery_admin/ui/widgets/login_card.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            var user = await LoginSheet(context).show();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            }
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
