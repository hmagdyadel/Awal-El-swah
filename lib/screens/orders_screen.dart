import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أول السواح'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Text'),
      ),
    );
  }
}
