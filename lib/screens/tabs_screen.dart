import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';

import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'category_screen.dart';
import 'favorites_screen.dart';

class TabScreen extends StatefulWidget {
  static const routeName = 'tab_screen';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;
  List<Map<String, Object>> _pages = [];

  void _selectPage(int value) {
    setState(() {
      _selectedPageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      {
        'title': 'المنتجات',
      },
      {
        'title': 'المنتجات المفضلة',
      }
    ];
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return new Future(() => true);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              _pages[_selectedPageIndex]['title'].toString() ==
                      'المنتجات المفضلة'
                  ? Consumer<Cart>(
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () => Navigator.of(context)
                            .pushNamed(CartScreen.routeName),
                      ),
                      builder: (_, cart, ch) => Badge(
                          value: cart.itemCount.toString(),
                          color: Colors.amber,
                          child: ch!),
                    )
                  : Container()
            ],
            title: Text(
              _pages[_selectedPageIndex]['title'].toString(),
            ),
          ),
          body: _pages[_selectedPageIndex]['title'].toString() == 'المنتجات'
              ? CategoriesScreen()
              : FavoriteScreen(),
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            backgroundColor: Colors.purple,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white,
            currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'المنتجات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'المنتجات المفضلة',
              ),
            ],
          ),
          drawer: AppDrawer(),
        ),
      ),
    );
  }
}
