import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/product_stream_provider.dart';
import 'providers/write_product_view_model_provider.dart';
import 'widgets/edit_product_quantity_sheet.dart';
import 'widgets/product_image_viewer.dart';
import 'write_product_page.dart';

class ProductPage extends ConsumerWidget {
  final String id;
  ProductPage({required this.id});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var productStream = watch(productProvider(id));
    return productStream.when(
      data: (product) {
        var model = context.read(writeProductViewModelProvider(product));

        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WriteProductPage(
                        product: product,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          "Are you sure you want to delete \"${product.name}\" product"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("No"),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            model.deleteProduct(product);
                          },
                          child: Text("Yes"),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            title: Text(product.name),
          ),
          bottomNavigationBar: SizedBox(
            height: 56,
            child: Material(
              color: Colors.white,
              elevation: 8,
              child: InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => EditProductQuantitySheet(
                    product: product,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      product.quantity.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          color: product.quantity == 0
                              ? Colors.red
                              : Colors.black),
                    ),
                    Icon(Icons.edit)
                  ],
                ),
              ),
            ),
          ),
          body: ListView(
            children: [
              Material(
                color: Colors.white,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ProductImageViewer(
                    images: product.images,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹' + product.price.toString() + " /",
                          style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          product.amount + " " + product.unit,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: product.active,
                          onChanged: (v) =>
                              model.setProductStatus(id: product.id, value: v!),
                        ),
                        Text("Active   "),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 24),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: product.popular,
                          onChanged: (v) => model.setProductPopularity(
                              id: product.id, value: v!),
                        ),
                        Text("Popular"),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  product.category,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(product.description),
              )
            ],
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }
}
