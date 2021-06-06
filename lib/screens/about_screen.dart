import '../screens/product_overview.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, ProductOver.routeName);
        return new Future(() => true);
      },
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text('عن التطبيق'),
            ),
            body: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height - 20,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 254, 229, 1),
                border: Border.all(
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Text(
                      'تطبيق منتجات أول السواح',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text('النسخة(1.0.0)',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text('تم تطويره في أبريل 2021', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 40),
                    Text('تم التطوير بواسطة',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('المهندس :',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('هيثم مجدي عادل',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 10, offset: Offset(0.9, 0.9))
                            ])),
                    SizedBox(height: 40),
                    ListTile(
                      leading: Image.asset(
                        'assets/icons/whats.png',
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        'Haitham Magdy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontSize: 24,
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        launch(
                            'https://api.whatsapp.com/send?phone=0201125516481');
                      },
                    ),
                  ],
                ),
              ),
            ),
            drawer: AppDrawer(),
          )),
    );
  }
}
