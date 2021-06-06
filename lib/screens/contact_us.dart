import 'package:awal_el_swah/widgets/app_drawer.dart';

import '../screens/product_overview.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  static const routeName = "/contact_us";

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
            title: Text('تواصل معنا'),
          ),
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/face.png',
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      'صفحتنا علي الفيسبوك',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('تواصل معنا عن طريق صفحتنا علي الفيسبوك'),
                    onTap: () {
                      launch(
                          'https://web.facebook.com/profile.php?id=100066658878938');
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/whats.png',
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      'واتساب',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('تواصل معنا عن طريق الواتساب'),
                    onTap: () {
                      launch(
                          'https://api.whatsapp.com/send?phone=201280563786');
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Icon(
                        Icons.call,
                        size: 34,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      'إتصل بنا',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('تواصل معنا مباشرة'),
                    onTap: () {
                      launch("tel://01280563786");
                    },
                  ),
                  SizedBox(height: 40),
                  Text(
                    'العنوان',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'اسيوط - ديروط - صنبو',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.teal,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  Text(
                    'بجوار كنيسة السيدة العذراء',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.teal,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'إدارة',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'ا/ عوض جاد',
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                        'ا/ إبرام أيوب',
                        style: TextStyle(fontSize: 22),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          launch("tel://01280563786");
                        },
                        child: Text(
                          '01280563786',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launch("tel://01200305987");
                        },
                        child: Text(
                          '01200305987',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 60),
                  Text(
                    'نحنُ دائماً في خدمتكم',
                    style: TextStyle(fontSize: 22, color: Colors.teal),
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
