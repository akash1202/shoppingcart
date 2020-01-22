import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/main2.dart';
import 'package:shoppingcart/screens/authenticate/authecnticate.dart';
import 'package:shoppingcart/screens/home/home_page.dart';
import 'package:shoppingcart/models/user.dart';

class Wrapper extends StatefulWidget {
  SharedPreferences _preferences;
  static const String USERNAME = "username";
  static const String USEREMAIL = "useremail";
  static const String USERPHOTO = "userphoto";
  static const String USERID = "userid";
  static const String IS_LOGGED_IN = "isloggedin";
  static const String CARTITEMSLIST = "cartitemslist";
  static const String CARTTOTALITEMS = "carttotalitems";
  static const String CARTTOTAL = "carttotal";
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {


  @override
  void initState() {
    saveUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      print("Wrapper :" + user.toString());
      saveUser();
      return MyApp2();
    }
  }

  saveUser() async {
    try {
      FirebaseUser firebaseUser;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      firebaseUser = await firebaseAuth.currentUser();
      print("abc " + firebaseUser.toString());
      if (preferences.getString(Wrapper.USERID) == null) {
        print("abc " + "User not Loggedin before");
      preferences.setString(Wrapper.USERID, firebaseUser.uid);
      preferences.setString(Wrapper.USERNAME, firebaseUser.displayName);
      preferences.setString(Wrapper.USEREMAIL, firebaseUser.email);
      preferences.setString(Wrapper.USERPHOTO, firebaseUser.photoUrl);
      }else{
        print("abc " + "User Already Loggedin before");
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
