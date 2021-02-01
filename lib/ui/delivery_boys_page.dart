import 'package:flutter/material.dart';

class DeliveryBoysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Boys"),
      ),
      body: ListView(
        children: [
          Material(
            color: Colors.white,
            child: ListTile(
              trailing: IconButton(icon: Icon(Icons.call), onPressed: () {}),
              title: Text("Shivkumar Konade"),
              subtitle: Text("+919284103047"),
            ),
          ),
        ],
      ),
    );
  }
}
