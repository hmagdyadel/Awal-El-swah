import 'package:awal_el_swah/screens/product_overview.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatefulWidget {
  static const routeName = '/not-found-screen';

  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, ProductOver.routeName);
        return new Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('not_found_page'),
        ),
      ),
    );
  }
}
