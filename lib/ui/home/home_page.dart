import 'package:flutter/material.dart';

import '../../core/models/product.dart';
import '../../utils/utils.dart';
import '../product/write_product_page.dart';
import 'widgets/drawer_menu.dart';
import 'widgets/product_list_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Utils.categories.length,
      child: Scaffold(
        drawer: DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteProductPage(
                product: Product.empty(),
              ),
            ),
          ),
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Grocery App'),
          bottom: TabBar(
            tabs: Utils.categories
                .map(
                  (e) => Tab(
                    text: e,
                  ),
                )
                .toList(),
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: Utils.categories
              .map(
                (e) => ProductListView(category: e),
              )
              .toList(),
        ),
      ),
    );
  }
}
