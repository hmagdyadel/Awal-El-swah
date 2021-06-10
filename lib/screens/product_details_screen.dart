import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return new Future(() => false);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    loadedProduct.title.toString(),
                    style: TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                  background: Hero(
                    tag: loadedProduct.id.toString(),
                    child: InteractiveViewer(
                      child: FadeInImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: AssetImage('assets/icons/placeholder.jpg'),
                        image: NetworkImage(
                          loadedProduct.imageUrl.toString(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'السعر :',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          '${loadedProduct.price}  ج.م  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'الوزن :',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          '${loadedProduct.weight} جم  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'الوصف',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      child: Text(
                        loadedProduct.description.toString(),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(fontSize: 20, color: Colors.teal),
                      ),
                    ),
                    SizedBox(
                      height: 380,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
