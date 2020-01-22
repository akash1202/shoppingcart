import 'package:flutter/cupertino.dart';
import 'package:shoppingcart/screens/authenticate/login_page.dart';
import 'package:shoppingcart/screens/authenticate/signup.dart';

class Authenticate extends StatefulWidget{
  static String tag='screens.authenticate-tag';

  @override
  State<StatefulWidget> createState()=>_AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{
  bool showSigninPage=true;
  void toggleView(){
    setState(()=>showSigninPage=!showSigninPage);
  }
  @override
  Widget build(BuildContext context) {
    if(showSigninPage){
      return LoginPage(toggleView: toggleView);
    }else{
      return Signup(toggleView: toggleView);
    }
  }

}