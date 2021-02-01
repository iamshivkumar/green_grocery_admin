import 'package:flutter_riverpod/all.dart';

import 'address_view_model.dart';


final addressViewModelProvider = ChangeNotifierProvider<AddressViewModel>(
  (ref) => AddressViewModel(),
);
