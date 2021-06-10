import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('أول السواح')),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: 'add'),
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, AsyncSnapshot snapshot) =>
            //snapshot.connectionState ==
            //         ConnectionState.waiting
            //     ? Center(child: CircularProgressIndicator())
            //     :
            RefreshIndicator(
                child: Consumer<Products>(
                  builder: (ctx, productData, _) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                        itemCount: productData.items!.length,
                        itemBuilder: (_, index) => Column(
                              children: [
                                UserProductItem(
                                    id: productData.items![index].id.toString(),
                                    title: productData.items![index].title
                                        .toString(),
                                    imageUrl: productData.items![index].imageUrl
                                        .toString()),
                                Divider(),
                              ],
                            )),
                  ),
                ),
                onRefresh: () => _refreshProducts(context)),
      ),
    );
  }
}
