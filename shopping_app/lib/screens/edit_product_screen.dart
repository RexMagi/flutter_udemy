import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product = Provider.of<Products>(
          context,
          listen: false,
        ).findById(productId);
        _editedProduct = product;
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_editedProduct == null || _editedProduct.id.isEmpty) {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } else {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_editedProduct.id, _editedProduct);
        }
      } catch (ex) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('An error occurred!'),
              content: Text('Something went wrong.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Okay'),
                )
              ],
            );
          },
        );
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _editedProduct.title,
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (title) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: title,
                              description: _editedProduct.id,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _editedProduct.price.toString(),
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          onSaved: (price) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              isFavorite: _editedProduct.isFavorite,
                              description: _editedProduct.id,
                              price: double.tryParse(price),
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            var price = double.tryParse(value);
                            if (value.isEmpty) {
                              return 'Please enter a price.';
                            } else if (price != null) {
                              return 'Please enter a valid number.';
                            } else if (price >= 0) {
                              return 'Please enter a number greater than 0.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _editedProduct.description,
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          focusNode: _descriptionFocusNode,
                          keyboardType: TextInputType.multiline,
                          onSaved: (desc) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: desc,
                              isFavorite: _editedProduct.isFavorite,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a descrption';
                            } else if (value.length <= 100) {
                              return 'Please enter a descrption greater than 100 characters.';
                            }
                            return null;
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a Url')
                                  : FittedBox(
                                      child: Image.network(
                                          _imageUrlController.text),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image Url'),
                                keyboardType: TextInputType.url,
                                focusNode: _imageUrlFocusNode,
                                controller: _imageUrlController,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _saveForm(),
                                onSaved: (url) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    isFavorite: _editedProduct.isFavorite,
                                    imageUrl: url,
                                  );
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter an image url';
                                  } else if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid URL.';
                                  } else if (!value.endsWith('.png') &&
                                      !value.endsWith('jpg') &&
                                      !value.endsWith('jpeg')) {
                                    return 'Please enter a valid image URL.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }
}
