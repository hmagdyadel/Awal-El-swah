import 'dart:io';
import '../providers/products.dart';
import '../providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _weightFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    category: '',
    title: '',
    description: '',
    price: 0,
    weight: 0.0,
    imageUrl: '',
  );
  var _initialValues = {
    'title': '',
    'category': '',
    'description': '',
    'price': '',
    'weight': '',
    'imageUrl': '',
  };
  var _isLoading = false;
  var _isInit = true;
  String? _selectedCategory;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;

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
      await Provider.of<Products>(context, listen: false).updateProduct(
        id: _editedProduct.id.toString(),
        category: category,
        title: title,
        description: description,
        price: price,
        weight: weight,
        imageUrl: imageUrl,
      );
    } else {
      try {
        print('product image url is:$imageUrl');
        await Provider.of<Products>(context, listen: false).addProduct(
          category: category!,
          title: title!,
          price: price!,
          weight: weight!,
          description: description!,
          imageUrl: imageUrl!,
        );
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
    _priceFocusNode.dispose();
    _weightFocusNode.dispose();
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
          'category': _editedProduct.category.toString(),
          'description': _editedProduct.description.toString(),
          'price': _editedProduct.price!.toString(),
          'weight': _editedProduct.weight!.toString(),
          'imageUrl': '',
        };
      }
      _isInit = false;
    }
  }

  String? category;
  String? id;
  String? title;
  String? description;
  double? price;
  double? weight;
  String? image;
  bool? isFavorite;

  List _catList = [
    'لحوم',
    'عسل نحل',
    'جبن والبان',
    'توابل وبهارات',
    'بقوليات',
    'مشروبات',
    'أسماك مملحة',
    'زيوت طبيعية',
    'مخللات',
    'منظفات',
    'تسالي',
    'خلطات وتتبيلات',
    'خضروات مجمدة',
    'منتجات صيامي'
  ];

  @override
  Widget build(BuildContext context) {
    final String? productId =
        ModalRoute.of(context)!.settings.arguments as String;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: productId == 'add'
              ? Center(child: Text('إضافة منتج'))
              : Center(child: Text('تعديل منتج')),
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
                      Row(
                        children: [
                          Text(
                            'اختر القسم :',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 30),
                          DropdownButton(
                            elevation: 0,
                            style: TextStyle(fontSize: 16, color: Colors.teal),
                            hint: Text('اختر القسم'),
                            value: _selectedCategory,
                            items: _catList.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Column(
                                  children: [
                                    Text(item!.toString()),
                                    Divider(
                                      height: 1,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _selectedCategory = newVal.toString();
                                category = _selectedCategory;
                              });
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  category: _selectedCategory,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  weight: _editedProduct.weight,
                                  imageUrl: _editedProduct.imageUrl,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        initialValue: _initialValues['title'].toString(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide()),
                          labelText: 'اسم المنتج',
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
                          setState(() {
                            title = value;
                          });
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              category: _editedProduct.category,
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
                          setState(() {
                            price = double.tryParse(value!);
                          });
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              category: _editedProduct.category,
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
                          setState(() {
                            description = value;
                          });
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              category: _editedProduct.category,
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
                          setState(() {
                            weight = double.tryParse(value!);
                          });
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              category: _editedProduct.category,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              weight: double.tryParse(value.toString()),
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.grey,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : null,
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () => _pickImage(ImageSource.camera),
                                icon: Icon(
                                  Icons.photo_camera_outlined,
                                  color: Colors.purple,
                                ),
                                label: Text(
                                  'الكاميرا',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.purple),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                icon: Icon(
                                  Icons.image_outlined,
                                  color: Colors.purple,
                                ),
                                label: Text(
                                  'معرض الصور',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.purple),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _pickImage(ImageSource src) async {
    final pickedImageFile =
        await _picker.getImage(source: src, maxWidth: 300, maxHeight: 200);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      Reference _ref =
          FirebaseStorage.instance.ref().child('images').child('image.jpg');
      UploadTask uploadTask = _ref.putFile(_pickedImage!);
      uploadTask.whenComplete(
        () async {
          try {
            image = await _ref.getDownloadURL();
          } catch (e) {
            print('the error is: $e');
          }
          print('the image is:$image');
          setState(() {
            imageUrl = image;
          });
        },
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك اختر صورة'),
        ),
      );
    }
  }
}
