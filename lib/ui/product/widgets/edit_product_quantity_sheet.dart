import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/models/product.dart';

class EditProductQuantitySheet extends HookWidget {
  final Product product;
  EditProductQuantitySheet({required this.product});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final width = MediaQuery.of(context).viewInsets.bottom;
    final _controller = useTextEditingController();
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8.0 + width),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              style: style.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(product.quantity.toString()),
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
                color: theme.accentColor,
                onPressed: () {
                  // context
                  //     .read(writeProductViewModelProvider)
                  //     .updateProductQuantity(
                  //       id: product.id,
                  //       qt: int.parse(_controller.text),
                  //     );
                  Navigator.pop(context);
                },
                child: Text("ADD"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
