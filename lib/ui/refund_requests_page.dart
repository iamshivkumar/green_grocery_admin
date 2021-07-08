import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/streams/refund_requests_stream_provider.dart';
import 'widgets/refund_request_card.dart';

class RefundRequestsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var refundRequestsStream = watch(refundRequestsStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Refund Requests"),
      ),
      body: refundRequestsStream.when(
        data: (refundRequests) => ListView(
          padding: EdgeInsets.all(2),
          children: refundRequests
              .map(
                (e) => RefundRequestCard(wallet: e,),
              )
              .toList(),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => SizedBox(),
      ),
    );
  }
}

