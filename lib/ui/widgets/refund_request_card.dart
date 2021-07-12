import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/wallet.dart';
import '../../core/view_models/refund_view_model/refund_view_model_provider.dart';
import 'two_text_row.dart';

class RefundRequestCard extends StatelessWidget {
  final Wallet wallet;
  RefundRequestCard({required this.wallet});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  "Wallet amount: \$" + wallet.amount.toString(),
                ),
                subtitle: Text(wallet.name),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: wallet.payments
                      .map(
                        (e) => TwoTextRow(
                            text1: e.id, text2: "\$" + e.amount.toString()),
                      )
                      .toList(),
                ),
              ),
              Consumer(
                builder: (context, watch, child) {
                  var model = watch(refundViewModelProvider(wallet));
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: model.loading
                        ? CircularProgressIndicator()
                        : MaterialButton(
                            onPressed: () => model.refund(),
                            child: Text("REFUND"),
                            color: Theme.of(context).accentColor,
                          ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
