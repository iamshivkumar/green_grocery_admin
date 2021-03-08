import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/streams/popular_product_list_stream_provider.dart';
import 'package:green_grocery_admin/core/streams/product_list_stream_provider.dart';
import 'add_edit_product_page.dart';
import 'widgets/drawer_menu.dart';
import 'widgets/product_card.dart';

class HomePage extends StatelessWidget {
  final List<String> categories = [
    'Popular',
    'Fruits',
    "Vegetables",
    'Food',
    'Drinks',
    'Snacks'
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        drawer: DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditProductPage(),
            ),
          ),
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Grocery App'),
          actions: [],
          bottom: TabBar(
            tabs: categories
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
          children: categories
              .map(
                (e) => ProductListView(category: e),
              )
              .toList(),
        ),
      ),
    );
  }
}

class ProductListView extends ConsumerWidget {
  final String category;
  ProductListView({@required this.category});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var productsStream = category != "Popular"
        ? watch(productListStreamProvider(Parameters(category, 6)))
        : watch(popularProductListStreamProvider);
    return productsStream.when(
      data: (products) => GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        padding: EdgeInsets.all(8),
        children: products
            .map((e) => ProductCard(
                  product: e,
                ))
            .toList(),
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
