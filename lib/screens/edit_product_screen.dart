
import '../providers/products.dart';

import '../providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _weightFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    weight: 0.0,
    imageUrl: '',
  );
  var _initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'weight': '',
    'imageUrl': '',
  };
  var _isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener((_updateImageUrl));
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id.toString(), _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('حدث خطأ'),
                  content: Text('هناك شئ خطأ حدث'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('تم'))
                  ],
                ));
      }

    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener((_updateImageUrl));
    _priceFocusNode.dispose();
    _weightFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final String? productId =
          ModalRoute.of(context)!.settings.arguments as String;

      if (productId != 'add') {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());
        _initialValues = {
          'title': _editedProduct.title.toString(),
          'description': _editedProduct.description.toString(),
          'price': _editedProduct.price!.toString(),
          'weight': _editedProduct.weight!.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl.toString();
      }
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('تعديل منتج')),
          actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        initialValue: _initialValues['title'].toString(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide()),
                          labelText: 'العنوان',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل قيمة';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              weight: _editedProduct.weight,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        initialValue: _initialValues['price'].toString(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide()),
                          labelText: 'السعر',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل السعر';
                          }
                          if (double.tryParse(value) == null) {
                            return 'من فضلك ادخل السعر';
                          }
                          if (double.tryParse(value)! <= 0) {
                            return 'من فضلك ادخل سعر اكبر من الصفر';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.tryParse(value.toString()),
                              weight: _editedProduct.weight,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        initialValue: _initialValues['description'].toString(),
                        maxLines: 3,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide()),
                          labelText: 'وصف المنتج',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_weightFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل وصف للمنتج';
                          }
                          if (value.length <= 10) {
                            return 'من فضلك ادخل وصف اكبر من 10 احرف';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value,
                              price: _editedProduct.price,
                              weight: _editedProduct.weight,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.number,
                        initialValue: _initialValues['weight'].toString(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide()),
                          labelText: 'الوزن',
                        ),
                        focusNode: _weightFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل الوزن';
                          }
                          if (double.tryParse(value) == null) {
                            return 'من فضلك ادخل السعر';
                          }
                          if (double.tryParse(value)! <= 0) {
                            return 'من فضلك ادخل وزن اكبر من الصفر';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              weight: double.tryParse(value.toString()),
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('ادخل الصورة')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: TextFormField(
                              textDirection: TextDirection.rtl,
                              controller: _imageUrlController,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide()),
                                labelText: 'ادخل الصورة',
                              ),
                              focusNode: _imageUrlFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'من فضلك الصورة';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https'))
                                  return 'من فضلك ادخل صورة صحيحة';
                                if (!value.endsWith('png') &&
                                    !value.endsWith('jpg') &&
                                    !value.endsWith('jpeg'))
                                  return 'من فضلك ادخل صورة صحيحة';
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    weight: _editedProduct.weight,
                                    imageUrl: value,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
