import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/popular_products_provider.dart';
import '../providers/products_provider.dart';
import 'product_card.dart';

class ProductListView extends ConsumerWidget {
  final String category;
  ProductListView({required this.category});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var productsStream = category != "Popular"
        ? watch(productsProvider(category))
        : watch(popularProductsProvider);
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
            .map(
              (e) => ProductCard(
                product: e,
              ),
            )
            .toList(),
      ),
      error: (error, stackTrace) {
        print(error);
        return Text(error.toString());
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
