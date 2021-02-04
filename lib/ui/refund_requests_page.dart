import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/streams/refund_requests_stream_provider.dart';
import 'package:green_grocery_admin/core/view_models/refund_view_model/refund_view_model_provider.dart';

class RefundRequestsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var refundRequestsStream = watch(refundRequestsStreamProvider);
    var model = watch(refundViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Refund Requests"),
      ),
      body: refundRequestsStream.when(
        data: (refundRequests) => SingleChildScrollView(
          child: ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (panelIndex, isExpanded) => model
                .setWallet(!isExpanded ? refundRequests[panelIndex] : null),
            children: refundRequests
                .map(
                  (e) => ExpansionPanel(
                    isExpanded: e == model.wallet,
                    canTapOnHeader: true,
                    headerBuilder: (context, isExpanded) => ListTile(
                      title: Text(
                        "\$" + e.amount.toString(),
                      ),
                      subtitle: Text(e.name),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Payment IDs"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: e.paymentIds
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Text(e),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: model.loading
                                ? CircularProgressIndicator()
                                : MaterialButton(
                                    onPressed: ()=>model.refund(),
                                    child: Text("Refund"),
                                    color: Theme.of(context).primaryColor,
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
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
