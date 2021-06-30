import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text('عربتك'),
          ),
          body: Column(
            children: [
              Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الإجمالي',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Chip(
                        label: Text(
                          '${cart.totalAmount.toStringAsFixed(2)}  £',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.purple,
                      ),
                      OrderButton(cart: cart),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) => CartItem(
                          id: cart.items.values.toList()[i].id,
                          title: cart.items.values.toList()[i].title,
                          price: cart.items.values.toList()[i].price,
                          quantity: cart.items.values.toList()[i].quantity,
                          productId: cart.items.keys.toList()[i],
                        )),
              )
            ],
          )),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton({required this.cart});

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              TextStyle(fontWeight: FontWeight.bold),
            ),
            foregroundColor: MaterialStateProperty.all(Colors.purple)),
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Order>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);

                String text =  Provider.of<Cart>(context,listen: false).whatsOrder;

                await launch(
                    'https://api.whatsapp.com/send?phone=201280563786&text=$text');
                setState(() {
                  _isLoading = false;
                });

                widget.cart.clear();
              },
        child: _isLoading ? CircularProgressIndicator() : Text('اُطلب الآن'));
  }
}
