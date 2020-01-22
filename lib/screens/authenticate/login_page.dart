import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/screens/home/home_page.dart';
import 'package:shoppingcart/screens/wrapper.dart';
import 'package:shoppingcart/services/auth.dart';
import 'package:shoppingcart/sign_in.dart';
import 'package:shoppingcart/screens/authenticate/signup.dart';
import 'package:shoppingcart/tools/progressdialog.dart';
import 'package:shoppingcart/tools/textInputDecoration.dart';

class LoginPage extends StatefulWidget {
  static String tag="login-page";
  final  Function toggleView;

  LoginPage({ this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences _preferences;
  BuildContext context;
  AuthService auth= AuthService();
  final _formkey= GlobalKey<FormState>();
  String error='';
  String emailText='';
  String passwordText='';
  bool loading =false;
  static const String USERNAME="username";
  static const String USEREMAIL="useremail";
  static const String USERPHOTO="userphoto";
  static const String USERID="userid";

  @override
  void initState() {
  SharedPreferences.getInstance().then((preferences){
    setState(()=>{
      this._preferences=preferences,
    });
  });
  }



  @override
  Widget build(BuildContext context) {
    this.context=context;
    final logo=Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius:70.0,
        child:FlatButton.icon(onPressed: ()=>widget.toggleView,
          icon: new Icon(Icons.person), label: Text('Login')),
      ),
    );
  final email=TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    initialValue: '',
    decoration: textInputDecoration.copyWith(
      hintText: 'email',
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
    ),
    validator: (val)=> val.isEmpty ? 'Enter an email' : null,
    onChanged: (val){
    setState(() {
     emailText=val;
    });
    },
  );
  final password=TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    initialValue: '',
    obscureText: true,
    decoration: textInputDecoration.copyWith(
      hintText: 'password',
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
    ),
    validator: (val)=> val.length<8 ? 'Enter a password with atleast 8+ character' : null,
    onChanged: (val){
      setState(() {
        passwordText=val;
      });
    },
  );
  final loginButton=Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () async{
      if(_formkey.currentState.validate()){
        setState(()=>loading=true);
        dynamic result =await auth.signInWithEmailAndPassword(emailText, passwordText);
        if(result==null){
          setState(() {
            loading= false;
            error="Wrong Signin credential!!";
          });
        }else{
         setState(() {
           loading=false;
           error="Success";
         });
          Route route= MaterialPageRoute( builder: (context)=> Wrapper());
          Navigator.pushReplacement(context, route);
        }
      }

        //Navigator.push((context),MaterialPageRoute(builder: (context)=>HomePage()));
        _googlesignInButton();
      },
      padding:EdgeInsets.all(12),
      color: Colors.green,
      child: Text('Log In',style: TextStyle(color:Colors.white,fontSize :17.0)), 
    ),
  );
  final forgotLabel=FlatButton(
    child :Text('Dont have and account? Signup',
    style:TextStyle(color:Colors.purple,fontSize: 15),
  ),
  onPressed: (){
    Navigator.push(context,MaterialPageRoute(builder:(context){
      return new Signup();
    })
    );
  },
  );

    return loading ? ProgressDialog() :
    WillPopScope(
        onWillPop: () =>
            showDialog<bool>(
                context: context,
                builder: (c) =>
                    AlertDialog(
                      title: Text('Warning'),
                      content: Text('Do you really want to exit?'),
                      actions: <Widget>[FlatButton(
                        child: Text('Yes'),
                        onPressed: () => Navigator.pop(c, true),
                      ),
                        FlatButton(
                          child: Text('No'),
                          onPressed: () => Navigator.pop(c, false),
                        )
                      ],
                    )
            ),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Form(
              key: _formkey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  logo,
                  SizedBox(height: 50.0),
                  email,
                  SizedBox(height: 15.0),
                  password,
                  SizedBox(height: 24.0),
                  loginButton,
                  Text(error,style: TextStyle(color: Colors.red,fontSize: 14.0)),
                  forgotLabel,
                  _googlesignInButton()
                ],
              ),
            ))
        ));
  }

  Widget _googlesignInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete((){
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder:(context){
          //       return FirstScreen();
          //   }
          // ));
          //Navigator.push((context),MaterialPageRoute(builder: (context)=>HomePage()));


          _saveUser();

          Route route = MaterialPageRoute(builder: (context) => HomePage());
          Navigator.pushReplacement(context, route);
          //Navigator.of(context).pushNamed(HomePage.tag);
        });

      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<FirebaseUser> _saveUser() async {

      FirebaseUser firebaseUser;
      FirebaseAuth.instance.currentUser().then((user){
        firebaseUser=user;
        showSnackbar(user.toString());
      });
      _preferences.setString(USERID, firebaseUser.uid);
      _preferences.setString(USERNAME, firebaseUser.displayName);
      _preferences.setString(USEREMAIL, firebaseUser.email);
      _preferences.setString(USERPHOTO, firebaseUser.photoUrl);
  }

  void showSnackbar(String message){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }


}