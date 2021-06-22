import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Order;
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('طلباتك')),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, AsyncSnapshot snapshot) {
              if (snapshot.error != null) {
                return Center(
                  child: Text('حدث خطأ ما'),
                );
              } else {
                return Consumer<Order>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, index) =>
                        OrderItem(orderData.orders[index]),
                  ),
                );
              }

          },
        ),
      ),
    );
  }
}
