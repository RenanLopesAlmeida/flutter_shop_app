import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/product.dart';
import 'package:shop_app/src/providers/products_provider.dart';

import 'utils/validators/edit_product_validators.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      print(_imageUrlController.text.endsWith('.jpg').toString());
      if ((_imageUrlController.text.isEmpty) ||
          !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.png')) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    Provider.of<ProductsProvider>(context, listen: false)
        .addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    return EditProductValidators.titleValidator(value);
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      title: newValue,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                  },
                  validator: (value) {
                    return EditProductValidators.priceValidator(value);
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(newValue),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: (_imageUrlController.text.isEmpty)
                          ? Center(
                              child: Text('Enter a URL'),
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(labelText: 'Image URL'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          return EditProductValidators.imageURLValidator(value);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.imageUrl,
                            imageUrl: newValue,
                            id: null,
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    return EditProductValidators.descriptionValidator(value);
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: newValue,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
                SizedBox(height: 20),
                Container(
                  height: 55,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Edit Product',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _saveForm,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
