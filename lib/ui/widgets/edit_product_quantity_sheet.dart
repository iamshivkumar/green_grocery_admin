import 'package:flutter/material.dart';
import 'package:green_grocery_admin/core/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/view_models/add_edit_product_view_model/add_edit_product_view_model_provider.dart';

class EditProductQuantitySheet extends StatefulWidget {
  final Product product;
  EditProductQuantitySheet({this.product});

  @override
  _EditProductQuantitySheetState createState() =>
      _EditProductQuantitySheetState();
}

class _EditProductQuantitySheetState extends State<EditProductQuantitySheet> {
  TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.product.quantity.toString()),
                  ),
                  Expanded(
                    child: Icon(Icons.add),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      onChanged: (newText) {},
                    ),
                  )
                ],
              ),
            ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL"),
                ),
                MaterialButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    context
                        .read(addEditProductViewModelProvider)
                        .updateProductQuantity(
                          id: widget.product.id,
                          qt: int.parse(_controller.text),
                        );
                    Navigator.pop(context);
                  },
                  child: Text("ADD"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
