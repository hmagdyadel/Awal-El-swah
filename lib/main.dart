import 'package:awal_el_swah/screens/about_screen.dart';
import 'package:awal_el_swah/screens/contact_us.dart';

import '../screens/cart_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/not_found_Screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/user_product_screen.dart';

import '../screens/product_overview.dart';
import '../screens/splash_screen.dart';

import '../screens/auth_screen.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/products.dart';

import '../providers/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Order()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'منتجات أول السواح',
          theme: ThemeData(
            buttonColor: Colors.black87,
            cardColor: Colors.white,
            shadowColor: Colors.white,
            primarySwatch: Colors.purple,
            canvasColor: Color.fromRGBO(255, 254, 229, 1),
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                    color: Color.fromRGBO(20, 50, 50, 1),
                  ),
                  headline6: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
          ),
          // home: AuthScreen(),
          home: auth.isAuth
              ? ProductOver()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, AsyncSnapshot authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductOver.routeName: (ctx) => ProductOver(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrderScreen.routeName: (_) => OrderScreen(),
            UserProductScreen.routeName: (_) => UserProductScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            AuthScreen.routeName: (_) => AuthScreen(),
            NotFoundPage.routeName: (_) => NotFoundPage(),
            ContactUs.routeName: (_) => ContactUs(),
            AboutApp.routeName: (_) => AboutApp(),
          },
        ),
      ),
    );
  }
}
