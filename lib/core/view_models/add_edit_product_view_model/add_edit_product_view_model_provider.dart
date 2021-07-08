import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_edit_product_view_model.dart';

final addEditProductViewModelProvider =
    ChangeNotifierProvider<AddEditProductViewModel>(
  (ref) => AddEditProductViewModel(),
);
