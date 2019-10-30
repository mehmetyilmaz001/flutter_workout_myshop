import 'package:flutter/material.dart';
import 'package:flutter_workout_myshop/providers/product.dart';
import 'package:flutter_workout_myshop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';

  EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = false;
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var _initValues = {'title': '', 'description': '', 'price': '', 'imageUrl': ''};

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Load created product for edit
    if (!_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': ''
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = true;
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
      //This need for to change image preview
      setState(() {});

      String validateImageUrlRes = validateImageUrl(_imageUrlController.text);
      if (validateImageUrlRes != null) {
        return;
      }
    }
  }

  String validateImageUrl(val) {
    if (val.isEmpty) {
      return 'Please enter image URL';
    }

    if (!val.startsWith('http') || !val.startsWith('https')) {
      return 'Please enter a valid image URL';
    }

    return null;
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();
    if(isEditMode()){
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
    }else{
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    
    Navigator.of(context).pop();
  }

  bool isEditMode(){
    return _editedProduct.id != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode() ? 'Edit Product' : 'New Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (val) {
                  _editedProduct = Product(
                      title: val,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite
                      );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter price';
                  }

                  if (double.tryParse(val) == null) {
                    return 'Please enter a valid price';
                  }

                  if (double.parse(val) <= 0) {
                    return 'Please enter a number greater then zero';
                  }

                  return null;
                },
                onSaved: (val) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(val),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite
                      );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please provide a value';
                  }

                  if (val.length < 10) {
                    return 'Sholud be at least 10 characters';
                  }
                  return null;
                },
                onSaved: (val) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: val,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite
                    );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (val) {
                        return validateImageUrl(val);
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: val,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite
                          );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
