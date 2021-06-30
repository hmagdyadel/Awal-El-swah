import '../widgets/product_item.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  final String name;

  const ProductsGrid(this.showFav, this.name);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = !showFav
        ? productData.filteredItems(name)
        : name != ''
            ? productData.favoriteCat(name)
            : productData.favoriteItems;

    return products!.isEmpty
        ? Center(
            child: Text(
              'لا توجد منتجات!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 5 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ),
          );
  }
}
