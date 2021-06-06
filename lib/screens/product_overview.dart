import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOver extends StatefulWidget {
  static const routeName = '/product-over-screen';

  @override
  _ProductOverState createState() => _ProductOverState();
}

class _ProductOverState extends State<ProductOver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: AppDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          child: Center(),
        ),
      ),
    );
  }
}
