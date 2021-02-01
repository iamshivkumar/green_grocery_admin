import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_grocery_admin/core/view_models/add_edit_product_view_model/add_edit_product_view_model_provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'widgets/my_image_picker.dart';

class AddEditProductPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final bool forEdit;
  AddEditProductPage({this.forEdit = false});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var model = watch(addEditProductViewModelProvider);
    return WillPopScope(
      onWillPop: () async {
        model.disposeModel();
        return true;
      },
      child: ModalProgressHUD(
        inAsyncCall: model.loading,
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (model.files.isEmpty) {
                await Fluttertoast.showToast(
                    msg: "Add minimum one image of product");
              }

              if (_formKey.currentState.validate() && model.files.isNotEmpty) {
                _formKey.currentState.save();
                forEdit
                    ? await model.updateProduct()
                    : await model.addProduct();
                Navigator.pop(context);
                model.disposeModel();
              }
            },
            label: Text(forEdit ? "Save" : "Add"),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
                model.disposeModel();
              },
            ),
            title: Text("Add Product"),
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
                            onChanged: model.setCategory,
                            items: model.categories
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
                        initialValue:
                            model.product != null ? model.product.name : "",
                        onSaved: model.setName,
                        validator: (value) =>
                            value.isEmpty ? "Enter Name" : null,
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
                            onCropped: (file) => model.addImage(file),
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
                      children: model.files
                          .map(
                            (e) => Material(
                              color: Colors.white,
                              child: Stack(
                                clipBehavior: Clip.antiAlias,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(e),
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
                        initialValue: model.product != null
                            ? model.product.amount.split(" ").first
                            : "",
                        validator: (value) =>
                            value.isEmpty ? "Enter Amount" : null,
                        onSaved: model.setAmount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Amount",
                          suffix: SizedBox(
                            height: 20,
                            child: DropdownButton<String>(
                              underline: SizedBox(),
                              value: model.amountType,
                              elevation: 16,
                              onChanged: model.setAmountType,
                              items: model.amountTypes
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                        initialValue: model.product != null
                            ? model.product.price.toString()
                            : "",
                        validator: (value) =>
                            value.isEmpty ? "Enter Price" : null,
                        onSaved: model.setPrice,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Price", prefixText: " ₹ "),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: model.product != null
                            ? model.product.quantity.toString()
                            : "",
                        validator: (value) =>
                            value.isEmpty ? "Enter Quantity" : null,
                        onSaved: model.setQuantity,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Quantity"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: model.product != null
                            ? model.product.description
                            : "",
                        validator: (value) =>
                            value.isEmpty ? "Enter about product" : null,
                        onSaved: model.setDescription,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 10,
                        decoration: InputDecoration(labelText: "About Product"),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: model.active, onChanged: model.setActive),
                        Text("Active"),
                        SizedBox(
                          width: 16,
                        ),
                        Checkbox(
                            value: model.popular, onChanged: model.setPopular),
                        Text("Popular"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
