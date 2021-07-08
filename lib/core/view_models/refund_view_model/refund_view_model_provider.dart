import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/wallet.dart';
import 'refund_view_model.dart';

final refundViewModelProvider = ChangeNotifierProvider.family<RefundViewModel,Wallet>(
  (ref,wallet) => RefundViewModel(wallet: wallet),
);
