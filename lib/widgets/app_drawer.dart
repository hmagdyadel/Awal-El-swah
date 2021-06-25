import 'package:awal_el_swah/screens/favorites_screen.dart';

import '../screens/tabs_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/about_screen.dart';
import '../screens/contact_us.dart';
import '../screens/product_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  buildListTile(title, icon, tapHandler, double fontSize) {
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
          fontSize: fontSize,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  TextEditingController _textEditingController = TextEditingController();

  String? codeDialog;

  String? valueText;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, TabScreen.routeName);
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
                          .pushReplacementNamed(TabScreen.routeName);
                    },
                    24.0,
                  ),
                  buildListTile(
                    'الطلبات',
                    Icons.payment,
                    () {
                      Navigator.pushReplacementNamed(
                          context, OrderScreen.routeName);
                    },
                    24.0,
                  ),
                  Divider(height: 10, color: Colors.black54),
                  buildListTile(
                    'تواصل معنا',
                    Icons.contact_page_outlined,
                    () {
                      Navigator.of(context)
                          .pushReplacementNamed(ContactUs.routeName);
                    },
                    24.0,
                  ),
                  buildListTile(
                    'عن التطبيق',
                    Icons.info_outline,
                    () {
                      Navigator.of(context)
                          .pushReplacementNamed(AboutApp.routeName);
                    },
                    24.0,
                  ),
                  Divider(height: 10, color: Colors.black54),
                  buildListTile(
                    'تسجيل الخروج',
                    Icons.logout,
                    () {
                      Provider.of<Auth>(context, listen: false).logout();
                      Navigator.of(context)
                          .pushReplacementNamed(AuthScreen.routeName);
                    },
                    24.0,
                  ),
                  if (userId == 'jZbtW288QlY92q9j5rbz7dzSi222')
                    buildListTile(
                      'التحكم في المنتجات',
                      Icons.edit,
                      () async {
                        await _displayTextInputDialog(context);
                      },
                      18.0,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(255, 254, 229, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32))),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'ادخل الرقم السري',
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ),
              ],
            ),
            content: TextField(
              textAlign: TextAlign.right,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textEditingController,
              decoration: InputDecoration(hintText: 'ادخل الرقم السري'),
            ),
            actions: [
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    Navigator.pop(ctx);
                  });
                },
                child: Text(
                  'إلغاء',
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.green,
                textColor: Colors.white,
                child: Text('موافق'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                  });

                  Navigator.pop(ctx);
                  if (codeDialog == '1234') {
                    codeDialog = '';
                    valueText = '';
                    Navigator.of(context)
                        .pushReplacementNamed(UserProductScreen.routeName);
                  }
                },
              ),
            ],
          );
        });
  }
}
