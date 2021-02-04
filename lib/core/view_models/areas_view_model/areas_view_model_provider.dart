import 'package:flutter_riverpod/all.dart';

import 'areas_view_model.dart';


final addressViewModelProvider = ChangeNotifierProvider<AreasViewModel>(
  (ref) => AreasViewModel(),
);
