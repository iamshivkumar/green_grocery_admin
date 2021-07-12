import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/models/product.dart';

import 'write_product_view_model.dart';

final writeProductViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<WriteProductViewModel, Product>(
  (ref, product) => WriteProductViewModel(product),
);
