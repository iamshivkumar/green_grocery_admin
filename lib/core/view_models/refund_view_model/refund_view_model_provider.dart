import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/view_models/refund_view_model/refund_view_model.dart';

final refundViewModelProvider = ChangeNotifierProvider.autoDispose<RefundViewModel>(
  (ref) => RefundViewModel(),
);
