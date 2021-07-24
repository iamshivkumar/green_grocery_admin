import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/models/product.dart';
import '../../utils/utils.dart';
import 'providers/write_product_view_model_provider.dart';
import 'widgets/my_image_picker.dart';

class WriteProductPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final Product product;
  WriteProductPage({required this.product});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    var model = watch(writeProductViewModelProvider(product));
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if ((model.files.cast() + model.images).isEmpty) {
                 Fluttertoast.showToast(
                    msg: "Add minimum one image of product");
                return;
              }
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  await model.writeProduct();
                } catch (e) {
                  print(e);
                }
                Navigator.pop(context);
              }
            },
            label: Text(product.id.isNotEmpty ? "Save" : "Add"),
          ),
          appBar: AppBar(
            title: Text("${product.id.isNotEmpty ? "Update" : "Add"} product"),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(fontSize: 16),
                          ),
                          DropdownButton<String>(
                            value: model.category,
                            elevation: 16,
                            onChanged: (v) => model.category = v!,
                            items: Utils.writeCategories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: model.product.name,
                        onSaved: (v) => model.product.name = v!,
                        validator: (value) => value!.isEmpty ? "Enter Name" : null,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Images',
                            style: TextStyle(fontSize: 16),
                          ),
                          MyImagePicker(
                            onPicked: (file) => model.addImage(file),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(8),
                      children: (model.images.cast() + model.files.cast())
                          .map(
                            (e) => Material(
                              color: Colors.white,
                              child: Stack(
                                clipBehavior: Clip.antiAlias,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: e is String
                                        ? Image.network(e)
                                        : Image.file(e),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        model.removeImage(e);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: model.product.amount,
                        validator: (value) =>
                            value!.isEmpty ? "Enter Amount" : null,
                        onSaved: (v) => model.product.amount = v!,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Amount",
                          suffix: SizedBox(
                            height: 20,
                            child: DropdownButton<String>(
                              underline: SizedBox(),
                              value: model.product.unit,
                              elevation: 16,
                              onChanged: (v) => model.unit = v!,
                              items: Utils.units
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: model.product.price.toInt().toString(),
                        validator: (value) => value!.isEmpty ? "Enter Price" : null,
                        onSaved: (v) => model.product.price = double.parse(v!),
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: "Price", prefixText: " ₹ "),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: model.product.quantity.toString(),
                        validator: (value) =>
                            value!.isEmpty ? "Enter Quantity" : null,
                        onSaved: (v) => model.product.quantity = int.parse(v!),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Quantity"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: model.product.description,
                        validator: (value) =>
                            value!.isEmpty ? "Enter about product" : null,
                        onSaved: (v) => model.product.description = v!,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 10,
                        decoration: InputDecoration(labelText: "About Product"),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: model.active,
                            onChanged: (v) => model.active = v!),
                        Text("Active"),
                        SizedBox(
                          width: 16,
                        ),
                        Checkbox(
                            value: model.popular,
                            onChanged: (v) => model.popular = v!),
                        Text("Popular"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
       model.loading? Material(
          color: theme.primaryColorLight.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ): SizedBox(),
      ],
    );
  }
}
