
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FilterOption { Favorites, All }

class ProductOver extends StatefulWidget {
  static const routeName = '/product-over-screen';

  @override
  _ProductOverState createState() => _ProductOverState();
}

class _ProductOverState extends State<ProductOver> {
  var _isLoading = false;
  var _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then(
          (_) => setState(
            () => _isLoading = false,
          ),
        )
        .catchError((_) => setState(
              () => _isLoading = false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('منتجات أول السواح')),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('منتجاتك المفضلة'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('كل المنتجات'),
                value: FilterOption.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOption selectedVal) {
              setState(() {
                if (selectedVal == FilterOption.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
            builder: (_, cart, ch) => Badge(
                value: cart.itemCount.toString(),
                color: Colors.amber,
                child: ch!),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: ProductsGrid(_showOnlyFavorites),
            ),
    );
  }
}
