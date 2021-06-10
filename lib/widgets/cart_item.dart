import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;

  const CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Are you Sure'),
                    content: Text('هل انت متأكد من حذف هذا المنتج ؟'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('لا')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('نعم'))
                    ],
                  ));
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('$price  £'),
                  ),
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('الإجمالي :  ${price * quantity}  £'),
              trailing: Text('$quantity  X'),
            ),
          ),
        ));
  }
}
