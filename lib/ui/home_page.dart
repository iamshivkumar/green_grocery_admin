import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:green_grocery_admin/core/streams/popular_product_list_stream_provider.dart';
import 'package:green_grocery_admin/core/streams/product_list_stream_provider.dart';
import 'package:green_grocery_admin/ui/delivery_boys_page.dart';
import 'package:green_grocery_admin/ui/orders_page.dart';
import 'package:green_grocery_admin/ui/refund_requests_page.dart';
import 'add_edit_product_page.dart';
import 'areas_page.dart';
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
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  title: Text("Orders"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrdersPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text("Delivery Boys"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeliveryBoysPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text("Refund Requests"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RefundRequestsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text("Areas"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AreasPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
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
      data: (products) => GridView.count(
        padding: EdgeInsets.all(8),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        crossAxisCount: 2,
        childAspectRatio: 0.75,
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
