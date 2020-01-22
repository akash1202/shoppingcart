import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart/screens/authenticate/authecnticate.dart';
import 'package:shoppingcart/screens/authenticate/login_page.dart';
import 'package:shoppingcart/screens/home/home_page.dart';
import 'package:shoppingcart/screens/homeWidget.dart';
import 'package:shoppingcart/screens/wrapper.dart';
import 'package:shoppingcart/services/auth.dart';
import 'main2.dart';
import 'models/user.dart';

void main() => runApp(MyApp1());

class MyApp1 extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    Authenticate.tag: (context) => Authenticate(),
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
  };

  //root part of the application

  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        routes: routes,
      ),
    );
    /*new MediaQuery(data: new MediaQueryData(), child: SafeArea(
      top: false,
      bottom: true,
      left:true,
      right: true,
      child: MaterialApp(
          title: 'My Amazon',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            fontFamily: 'Nunito',
          ),
          home: HomeWidget(),
          routes: routes,
        ),
    ));*/
  }
}
