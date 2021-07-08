import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/streams/popular_product_list_stream_provider.dart';
import '../../../core/streams/product_list_stream_provider.dart';
import 'product_card.dart';

class ProductListView extends ConsumerWidget {
  final String category;
  ProductListView({required this.category});
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
            .map(
              (e) => ProductCard(
                product: e,
              ),
            )
            .toList(),
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
