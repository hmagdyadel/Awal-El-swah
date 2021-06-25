import '../providers/products.dart';
import '../widgets/products_grid.dart';
import 'package:flutter/material.dart';
import '../screens/tabs_screen.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).favoriteItems;
    if (productData!.isEmpty) {
      return WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, TabScreen.routeName);
          return new Future(() => true);
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Text(
                "لم تقم بأضافة طعام مفضل لحد الآن - قم بأضافة بعض الاطعمة!"),
          ),
        ),
      );
    } else {
      return ProductsGrid(true, '');
    }
  }
}
