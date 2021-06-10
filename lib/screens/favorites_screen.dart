import '../providers/products.dart';
import '../widgets/products_grid.dart';
import 'package:flutter/material.dart';
import '../screens/tabs_screen.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).favoriteItems;
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var deviceWidth = MediaQuery.of(context).size.width;
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
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: deviceWidth <= 400 ? 400 : 500,
          childAspectRatio: isLandScape
              ? deviceWidth / (deviceWidth * 0.8)
              : deviceWidth / (deviceWidth * 0.93),
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: productData.length,
        itemBuilder: (ctx, index) {
          return ProductsGrid(true);
        },
      );
    }
  }
}
