import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/screens/authenticate/authecnticate.dart';
import 'package:shoppingcart/services/auth.dart';

import '../wrapper.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePage  createState() {
    return _HomePage();
  }
  //_HomePage  createState() => new _HomePage();

  static String tag='home-page';
  }

Future<FirebaseUser> getCurrentUser() async{
    return await FirebaseAuth.instance.currentUser();
}


class _HomePage extends State<HomePage> {
  BuildContext context;
  SharedPreferences preferences;
  String userName="name";
  String userEmail="email";
  String userId="id";
  String userPhoto="photo";

    @override
    void initState() {
      setUser();
     super.initState();
    }

    setUser() async{
       preferences=await SharedPreferences.getInstance();
      setState(() {
        userId = preferences.getString(Wrapper.USERID) ?? "ak id";
        userName = preferences.getString(Wrapper.USERNAME) ?? "ak name";
        userEmail = preferences.getString(Wrapper.USEREMAIL) ?? "ak email";
        userPhoto = preferences.getString(Wrapper.USERPHOTO) ?? "";
      });
    }

  @override
  Widget build(BuildContext context) {
    this.context=context;
    final profilepic= CircleAvatar(
        child:Padding(
            padding: EdgeInsets.all(16.0),
            child:CircleAvatar(
              radius:72.0,
              backgroundColor: Colors.transparent,
              //backgroundImage: AssetImage('assets/images/pro1.jpg'),
              child:Image.network(userPhoto,scale: 10,fit: BoxFit.cover),
            )
        )
    );
    final welcome=Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(userName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28,color: Colors.black),
      ),
    );
    final bio=Padding(
        padding:EdgeInsets.all(8.0),
        child:Text(userEmail,
          textAlign: TextAlign.center,
          style:TextStyle(fontSize: 16.0,color:Colors.black),
        )
    );
    final fav=Padding(
        padding:EdgeInsets.all(8.0),
        child:Text('No Status!!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0,color:Colors.black),
        )
    );
    final logoutButton=Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: (){
          AuthService().signOut();
          Navigator.of(context).pushNamed(Authenticate.tag);
          //Navigator.pop(context);
        },
        padding:EdgeInsets.all(12),
        color: Colors.green,
        child: Text('Logout',style: TextStyle(color:Colors.white,fontSize :17.0)),
      ),
    );
    final body=Container(
        width: MediaQuery.of(context).size.width,
        padding:EdgeInsets.all(28.0),
        decoration:BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.yellow[200],
            Colors.yellow[200],
          ]),
        ),
        child:Column(
          children: <Widget> [profilepic,welcome,bio,fav,logoutButton],
        )
    );

    return Scaffold(
      body:body,
    );
  }

  void showSnackbar(String message){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }


}