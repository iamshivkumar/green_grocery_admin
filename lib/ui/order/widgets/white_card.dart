import 'package:flutter/material.dart';

class WhiteCard extends StatelessWidget {
  final Widget child;
  WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: child,
        ),
      ),
    );
  }
}
