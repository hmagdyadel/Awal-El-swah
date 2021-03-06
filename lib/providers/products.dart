import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product>? _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   weight: 1.5,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   weight: 1.2,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   weight: 1.1,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   weight: 1,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String? authToken;
  String? userId;

  getData(String? token, String? uId, List<Product>? products) {
    authToken = token;
    userId = uId;
    _items = products;
    notifyListeners();
  }

  List<Product>? get items {
    return [..._items!];
  }

  List<Product>? get favoriteItems {
    return _items!.where((prodItem) => prodItem.isFavorite).toList();
  }

  List<Product> favoriteCat(String name) {
    return _items!
        .where((prodItem) => prodItem.isFavorite && prodItem.category == name)
        .toList();
  }

  List<Product> filteredItems(String name) {
    return _items!.where((prodItem) => prodItem.category == name).toList();
  }

  Product findById(String id) {
    return _items!.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    //final filteredString ='orderBy="category"&equalTo="name"';
    // Uri url = Uri.parse(
    //     'https://awal-elswah-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filteredString');
    Uri url = Uri.parse(
        'https://awal-elswah-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final res = await http.get(url);
      final Map<String, dynamic>? extractedData =
          json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://awal-elswah-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favRes = await http.get(url);
      final favData = json.decode(favRes.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          category: prodData['category'],
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          weight: prodData['weight'],
          isFavorite: favData == null ? false : favData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct({
    required String category,
    required String title,
    required String description,
    required double price,
    required double weight,
    required String imageUrl,
  }) async {
    print('the image in add product is:$imageUrl');
    final url =
        'https://awal-elswah-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'category': category,
            'title': title,
            'description': description,
            'price': price,
            'weight': weight,
            'imageUrl': imageUrl,
            'creatorId': userId,
          }));
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        category: category,
        title: title,
        description: description,
        price: price,
        weight: weight,
        imageUrl: imageUrl,
      );
      _items!.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct({
    String? id,
    String? category,
    String? title,
    String? description,
    double? price,
    double? weight,
    String? imageUrl,
  }) async {
    final prodIndex = _items!.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://awal-elswah-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'category': category,
            'title': title,
            'description': description,
            'price': price,
            'weight': weight,
            'imageUrl': imageUrl,
          }));
      _items![prodIndex] = Product(
        category: category,
        id: id,
        title: title,
        description: description,
        price: price,
        weight: weight,
        imageUrl: imageUrl,
      );
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> delete(String id) async {
    final url =
        'https://awal-elswah-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items!.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items![existingProductIndex];
    _items!.removeAt(existingProductIndex);
    notifyListeners();
    final res = await http.delete(Uri.parse(url));
    if (res.statusCode >= 400) {
      _items!.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('???? ???????? ?????? ?????? ????????????');
    }
    existingProduct = null;
  }
}
