import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: product.id.toString(),
                    child: InteractiveViewer(
                      child: FadeInImage(
                        width: MediaQuery.of(context).size.width - 60,
                        height: MediaQuery.of(context).size.height / 3.9,
                        placeholder: AssetImage('assets/icons/placeholder.jpg'),
                        image: NetworkImage(product.imageUrl.toString() != null
                            ? product.imageUrl.toString()
                            : 'assets/icons/placeholder.jpg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black54.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        '${product.title}',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black54.withOpacity(0.8),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${product.weight}  جم  ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${product.price} ج.م  ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.shopping_cart),
                          iconSize: 30,
                          onPressed: () {
                            cart.addItem(
                                product.id.toString(),
                                product.price!.toDouble(),
                                product.title.toString());
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('تم الإضافة إلي العربة'),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'إلغاء',
                                onPressed: () {
                                  cart.removeSingleItem(product.id.toString());
                                },
                              ),
                            ));
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              product.toggleFavoriteStatus(
                                  authData.token.toString(),
                                  authData.userId.toString());
                            },
                            color: Colors.pink,
                            iconSize: 30,
                            icon: Icon(product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border)),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

    //ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     child: GestureDetector(
    //       onTap: () => Navigator.of(context)
    //           .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
    //       child: Hero(
    //         tag: product.id.toString(),
    //         child: FadeInImage(
    //           placeholder: AssetImage('assets/icons/placeholder.jpg'),
    //           image: NetworkImage(product.imageUrl.toString()),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //     footer: GridTileBar(
    //       backgroundColor: Colors.black87,
    //       leading: Consumer<Product>(
    //         builder: (ctx, product, _) => IconButton(
    //             onPressed: () {
    //               product.toggleFavoriteStatus(
    //                   authData.token.toString(), authData.userId.toString());
    //             },
    //             color: Colors.pink,
    //             icon: Icon(product.isFavorite
    //                 ? Icons.favorite
    //                 : Icons.favorite_border)),
    //       ),
    //       title: Text(
    //         product.title.toString(),
    //         textAlign: TextAlign.center,
    //       ),
    //       trailing: IconButton(
    //         color: Colors.pink,
    //         icon: Icon(Icons.shopping_cart),
    //         onPressed: () {
    //           cart.addItem(product.id.toString(), product.price!.toDouble(),
    //               product.title.toString());
    //           Scaffold.of(context).hideCurrentSnackBar();
    //           Scaffold.of(context).showSnackBar(SnackBar(
    //             content: Text('تم الإضافة إلي العربة'),
    //             duration: Duration(seconds: 2),
    //             action: SnackBarAction(
    //               label: 'إلغاء',
    //               onPressed: () {
    //                 cart.removeSingleItem(product.id.toString());
    //               },
    //             ),
    //           ));
    //         },
    //       ),
    //),
    //   ),
    // );
  }
}
