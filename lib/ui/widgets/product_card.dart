import 'package:flutter/material.dart';
import 'package:green_grocery_admin/core/models/product.dart';
import 'package:green_grocery_admin/core/view_models/add_edit_product_view_model/add_edit_product_view_model_provider.dart';
import '../product_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({@required this.product});
  @override
  Widget build(BuildContext context) {
    var model = context.read(addEditProductViewModelProvider);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(id: product.id),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(product.images.first),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            product.name,
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Text(
                                '₹' + product.price.toString() + " / ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                product.amount,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0.5,
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: product.quantity!=0? ()=>model.updateProductQuantity(
                      id: product.id,
                      qt: -1
                    ):null,
                    child: Icon(Icons.remove_circle_outline),
                  ),
                  Text(product.quantity.toString()),
                  TextButton(
                    onPressed: ()=>model.updateProductQuantity(
                      id: product.id,
                      qt: 1
                    ),
                    child: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
