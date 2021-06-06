import '../screens/about_screen.dart';
import '../screens/contact_us.dart';
import '../screens/product_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  buildListTile(title, icon, tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Colors.purple,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Color.fromRGBO(20, 50, 50, 1),
          fontSize: 24,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, ProductOver.routeName);
        return new Future(() => true);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Drawer(
            elevation: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Container(),
                    accountEmail: InkWell(),
                    currentAccountPicture: CircleAvatar(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/icons/awal.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/categories.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildListTile(
                    'المنتجات',
                    Icons.category_outlined,
                    () {
                      Navigator.of(context)
                          .pushReplacementNamed(ProductOver.routeName);
                    },
                  ),
                  buildListTile(
                    'الطلبات',
                    Icons.payment,
                    () {
                      Navigator.pushReplacementNamed(
                          context, OrderScreen.routeName);
                    },
                  ),
                  Divider(height: 10, color: Colors.black54),
                  buildListTile(
                    'تواصل معنا',
                    Icons.contact_page_outlined,
                    () {
                      Navigator.of(context)
                          .pushReplacementNamed(ContactUs.routeName);
                    },
                  ),
                  buildListTile(
                    'عن التطبيق',
                    Icons.info_outline,
                    () {
                      Navigator.of(context)
                          .pushReplacementNamed(AboutApp.routeName);
                    },
                  ),
                  Divider(height: 10, color: Colors.black54),
                  buildListTile(
                    'تسجيل الخروج',
                    Icons.logout,
                    () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed(ProductOver.routeName);
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                  ),
                  buildListTile(
                    'التحكم في المنتجات',
                    Icons.edit,
                    () {
                      Navigator.of(context)
                          .pushReplacementNamed(UserProductScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
