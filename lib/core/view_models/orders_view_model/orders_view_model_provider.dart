import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/view_models/orders_view_model/orders_view_model.dart';

final ordersViewModelProvider = ChangeNotifierProvider<OrdersViewModel>(
  (ref) => OrdersViewModel(),
);
